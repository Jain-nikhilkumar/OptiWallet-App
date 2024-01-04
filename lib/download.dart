import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<Map<String, dynamic>> getDocumentData(BuildContext context, String documentId) async {
  try {
    // Store the context before entering the async function
    BuildContext localContext = context;

    // Reference to the Firestore collection
    CollectionReference<Map<String, dynamic>> collection =
    FirebaseFirestore.instance.collection('DID');

    // Reference to the specific document
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await collection.doc(documentId).get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Access the data in the document
      Map<String, dynamic> data = documentSnapshot.data()!;

      // Save data as a JSON file
      await saveDataAsJson(data, documentId);

      return data;
    } else {
      // Display a dialogue box using the locally stored context
      showDialog(
        context: localContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Document Not Found'),
            content: Text('The document with ID $documentId does not exist.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialogue box
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      print('Document does not exist');
      return {}; // or handle accordingly based on your use case
    }
  } catch (e) {
    print('Error fetching document: $e');
    return {}; // or handle accordingly based on your use case
  }
}

Future<void> saveDataAsJson(Map<String, dynamic> data, String documentId) async {
  try {
    // Get the application's local storage directory
    Directory directory = await getApplicationDocumentsDirectory();

    // Create a new file in the local storage directory
    File file = File('${directory.path}/$documentId.json');

    // Convert the data to JSON format
    String jsonData = jsonEncode(data);

    // Write the JSON data to the file
    await file.writeAsString(jsonData);

    print('Data saved as JSON file: ${file.path}');
  } catch (e) {
    print('Error saving data as JSON: $e');
  }
}
