import 'dart:convert';
import 'dart:io';

import 'package:OptiWallet/apihandler/api_handler.dart';
import 'package:OptiWallet/firebasehandles/auth_provider.dart';
import 'package:OptiWallet/firebasehandles/firestore_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

typedef DownloadCallback = void Function(Map<String, dynamic> jsonData);

void _showToast(String message, {Color backgroundColor = Colors.white, Color textColor = Colors.black}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}

Future<bool> getDocumentData(
    String email,
    String documentId, {
      String collectionId = "DID",
      DownloadCallback? downloadCallback,
    }) async {

  FirestoreHandler firestoreHandler = FirestoreHandler();
  try {

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        _showToast('Storage permission not granted', backgroundColor: Colors.redAccent, textColor: Colors.white);
        return false;
      }
    }

    Map<String, dynamic>? user = await firestoreHandler.getDocument('USER', email);
    List<String> creds = user?['credentials'];

    for(String id in creds){
      Map<String, dynamic>? data = await firestoreHandler.getDocument('DID', id);
      await saveDataAsJson(data!, id);
      // Notify the caller (UI) about the download completion
      if (downloadCallback != null) {
        downloadCallback(data);
      }
    }
    _showToast('Data saved successfully');
    firestoreHandler.closeFirestore();
    return true;

    // CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection(collectionId);
    //
    // DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await collection.doc(documentId).get();
    //
    // if (documentSnapshot.exists) {
    //   Map<String, dynamic> data = documentSnapshot.data()!;
    //   await saveDataAsJson(data, documentId);
    //   _showToast('Data saved successfully');
    //
    //   // Notify the caller (UI) about the download completion
    //   if (downloadCallback != null) {
    //     downloadCallback(data);
    //   }
    //
    //   return data;
    // } else {
    //   showDialog(
    //     context: localContext,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Document Not Found'),
    //         content: Text('The document with ID $documentId does not exist.'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text('OK'),
    //           ),
    //         ],
    //       );
    //     },
    //   );

      // return {};
    // }
  } catch (e) {
    _showToast('Error fetching document: $e');
    debugPrint('Error while getting Credentials');
    firestoreHandler.closeFirestore();
    return false;
  }
}

Future<void> saveDataAsJson(Map<String, dynamic> data, String documentId) async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      _showToast('Storage permission not granted');
      return;
    }

    Directory? directory = await getExternalStorageDirectory();
    File file = File('${directory?.path}/$documentId.json');
    String jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);

    _showToast('Data saved as JSON file: ${file.path}');
  } catch (e) {
    _showToast('Error saving data as JSON: $e');
  }
}

Future<List<Map<String, dynamic>>> getAllJsonMaps() async {
  try {
    Directory? directory = await getExternalStorageDirectory();
    List<FileSystemEntity>? files = directory?.listSync();
    List<Map<String, dynamic>> jsonMaps = [];

    for (var file in files!) {
      if (file is File && file.path.endsWith('.json')) {
        Map<String, dynamic> jsonMap = await convertJsonFileToMap(file);
        jsonMaps.add(jsonMap);
      }
    }

    return jsonMaps;
  } catch (e) {
    _showToast('Error getting and converting JSON files to maps: $e');
    return [];
  }
}

Future<Map<String, dynamic>> convertJsonFileToMap(File jsonFile) async {
  try {
    String jsonContent = await jsonFile.readAsString();
    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);
    return jsonMap;
  } catch (e) {
    _showToast('Error converting JSON file to map: $e');
    return {};
  }
}

bool _isSubset(List<dynamic> sublist, List<dynamic> list) {
  // Trim whitespace from left and right of each element in both lists
  List<String> trimmedList1 = sublist.map((e) => e.toString().trim()).toList();
  List<String> trimmedList2 = list.map((e) => e.toString().trim()).toList();

  // Check if every element in trimmedList1 is present in trimmedList2
  return trimmedList1.every((element) => trimmedList2.contains(element));
}

Future<List<Map<String, dynamic>>> getFilteredJsonFiles(List<dynamic> requiredTypes) async {
  try {
    Directory? directory = await getExternalStorageDirectory();
    List<FileSystemEntity>? files = directory?.listSync();

    List<Map<String, dynamic>> filteredJsonFiles = [];

    for (var file in files!) {
      if (file is File && file.path.endsWith('.json')) {
        String fileContent = await file.readAsString();
        Map<String, dynamic> jsonData = jsonDecode(fileContent);
        if (jsonData.containsKey("credentialDocument") &&
            jsonData["credentialDocument"].isNotEmpty) {
          var credentialDocuments = jsonData["credentialDocument"];

          bool matchEvery = _isSubset(requiredTypes, credentialDocuments["type"]);
          // _showToast("match: $matchEvery");

          if (matchEvery) {
            // print("Printing Credentials: $credentialDocuments");
            filteredJsonFiles.add(jsonData);
          }
        }
      }
    }

    return filteredJsonFiles;
  } catch (e) {
    print('Error getting filtered JSON files: $e');
    return [];
  }
}
