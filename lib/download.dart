import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<Map<String, dynamic>> getDocumentData(BuildContext context, String documentId) async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      var result = await Permission.storage.request();
      if (result != PermissionStatus.granted) {
        print('Storage permission not granted');
        return {};
      }
    }

    BuildContext localContext = context;

    CollectionReference<Map<String, dynamic>> collection =
    FirebaseFirestore.instance.collection('DID');

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await collection.doc(documentId).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data()!;
      await saveDataAsJson(data, documentId);
      showToast('Data saved successfully');
      return data;
    } else {
      showDialog(
        context: localContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Document Not Found'),
            content: Text('The document with ID $documentId does not exist.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      print('Document does not exist');
      return {};
    }
  } catch (e) {
    print('Error fetching document: $e');
    showToast('Error fetching document: $e', isError: true);
    return {};
  }
}

Future<void> saveDataAsJson(Map<String, dynamic> data, String documentId) async {
  try {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      print('Storage permission not granted');
      return;
    }

    Directory? directory = await getExternalStorageDirectory();
    File file = File('${directory?.path}/$documentId.json');
    String jsonData = jsonEncode(data);
    await file.writeAsString(jsonData);

    print('Data saved as JSON file: ${file.path}');
  } catch (e) {
    print('Error saving data as JSON: $e');
    showToast('Error saving data as JSON: $e', isError: true);
  }
}

void showToast(String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: isError ? Colors.white : Colors.white,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

Future<List<Map<String, dynamic>>> getAllJsonMaps() async {
  try {
    // Get the application's local storage directory
    Directory directory = await getApplicationDocumentsDirectory();

    // List all files in the directory
    List<FileSystemEntity> files = directory.listSync();

    // Filter out only JSON files
    List<Map<String, dynamic>> jsonMaps = [];

    for (var file in files) {
      if (file is File && file.path.endsWith('.json')) {
        // Convert each JSON file to a map
        Map<String, dynamic> jsonMap = await convertJsonFileToMap(file);
        jsonMaps.add(jsonMap);
      }
    }

    return jsonMaps;
  } catch (e) {
    print('Error getting and converting JSON files to maps: $e');
    return [];
  }
}

Future<Map<String, dynamic>> convertJsonFileToMap(File jsonFile) async {
  try {
    // Read the content of the JSON file
    String jsonContent = await jsonFile.readAsString();

    // Parse the JSON content into a map
    Map<String, dynamic> jsonMap = jsonDecode(jsonContent);

    return jsonMap;
  } catch (e) {
    print('Error converting JSON file to map: $e');
    return {};
  }
}