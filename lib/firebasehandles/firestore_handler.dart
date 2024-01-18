// firestore_handler.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHandler {
  late FirebaseFirestore _firestore; // Use late initialization

  // Constructor to initialize Firestore connection
  FirestoreHandler() {
    _firestore = FirebaseFirestore.instance;
    // Add any additional initialization steps if needed
  }

  // Close Firestore connection
  void closeFirestore() {
    _firestore.terminate(); // Close Firestore connection
    // Add any additional cleanup steps if needed
  }

  // Function to add a document to Firestore
  Future<bool> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).add(data);
      return true; // Successful operation
    } catch (e) {
      print("Error adding document: $e");
      return false; // Operation failed
    }
  }

  // Function to add a document to Firestore
  Future<bool> setDocument(String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).set(data);
      return true; // Successful operation
    } catch (e) {
      print("Error adding document: $e");
      return false; // Operation failed
    }
  }

  // Function to get a particular document from Firestore
  Future<Map<String, dynamic>?> getDocument(String collection, String documentId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection(collection).doc(documentId).get();

      if (documentSnapshot.exists) {
        // Document found, return its data
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        // Document does not exist
        print("Document with ID $documentId does not exist in collection $collection");
        return null;
      }
    } catch (e) {
      print("Error getting document: $e");
      return null;
    }
  }

  // Function to get documents from Firestore
  Future<List<Map<String, dynamic>>> getDocuments(String collection) async {
    List<Map<String, dynamic>> documents = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collection).get();
      for (var doc in querySnapshot.docs) {
        documents.add(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print("Error getting documents: $e");
    }

    return documents;
  }

  // Function to update a document in Firestore
  Future<bool> updateDocument(String collection, String documentId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
      return true; // Successful operation
    } catch (e) {
      print("Error updating document: $e");
      return false; // Operation failed
    }
  }

  // Function to delete a document from Firestore
  Future<bool> deleteDocument(String collection, String documentId) async {
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      return true; // Successful operation
    } catch (e) {
      print("Error deleting document: $e");
      return false; // Operation failed
    }
  }

  // Function to get all collections in Firestore
  Future<List<String>> getAllCollections() async {
    List<String> collections = [];

    try {
      QuerySnapshot querySnapshot = await _firestore.collectionGroup('').get();
      for (var doc in querySnapshot.docs) {
        collections.add(doc.reference.parent.id);
      }
    } catch (e) {
      print("Error getting collections: $e");
    }

    return collections;
  }
}
