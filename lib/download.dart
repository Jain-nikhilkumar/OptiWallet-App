import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef DownloadCallback = void Function(Map<String, dynamic> jsonData);

void showToast(String message, {Color backgroundColor = Colors.white, Color textColor = Colors.black}) {
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

Future<Map<String, dynamic>> getDocumentData(
    BuildContext context,
    String documentId, {
      String collectionId = "DID",
      DownloadCallback? downloadCallback,
    }) async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        showToast('Storage permission not granted', backgroundColor: Colors.redAccent, textColor: Colors.white);
        return {};
      }
    }

    BuildContext localContext = context;

    CollectionReference<Map<String, dynamic>> collection = FirebaseFirestore.instance.collection(collectionId);

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await collection.doc(documentId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      await saveDataAsJson(data, documentId);
      showToast('Data saved successfully');

      // Notify the caller (UI) about the download completion
      if (downloadCallback != null) {
        downloadCallback(data);
      }

      return data;
    } else {
      showDialog(
        context: localContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Document Not Found'),
            content: Text('The document with ID $documentId does not exist.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return {};
    }
  } catch (e) {
    showToast('Error fetching document: $e');
    return {};
  }
}

Future<void> saveDataAsJson(Map<String, dynamic> data, String documentId) async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      showToast('Storage permission not granted');
      return;
    }

    Directory? directory = await getExternalStorageDirectory();
    File file = File('${directory?.path}/$documentId.json');
    String jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);

    showToast('Data saved as JSON file: ${file.path}');
  } catch (e) {
    showToast('Error saving data as JSON: $e');
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
    showToast('Error getting and converting JSON files to maps: $e');
    return [];
  }
}

Future<Map<String, dynamic>> convertJsonFileToMap(File jsonFile) async {
  try {
    String jsonContent = await jsonFile.readAsString();
    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);
    return jsonMap;
  } catch (e) {
    showToast('Error converting JSON file to map: $e');
    return {};
  }
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

        if (jsonData.containsKey("credentialDocuments") &&
            jsonData["credentialDocuments"].isNotEmpty) {
          var credentialDocuments = jsonData["credentialDocuments"];

          if (credentialDocuments is Map<String, dynamic> &&
              credentialDocuments.containsKey("type") &&
              credentialDocuments["type"] is List &&
              credentialDocuments["type"].containsAll(requiredTypes)) {
            filteredJsonFiles.add(credentialDocuments);
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