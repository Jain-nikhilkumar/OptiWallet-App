import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDbOperations {
  late DatabaseReference _databaseReference;

  FirebaseDbOperations(FirebaseApp firebaseApp) {
    _initializeDatabase(firebaseApp);
  }

  void _initializeDatabase(FirebaseApp firebaseApp) {
    _databaseReference = FirebaseDatabase.instanceFor(app: firebaseApp).ref();
  }

  Future<void> writeData(String path, Map<String, dynamic> data) async {
    try {
      await _databaseReference.child(path).set(data);
      print('Data written successfully');
    } catch (e) {
      print('Error writing data: $e');
    }
  }

  Future<Map<String, dynamic>> readData(String path) async {
    try {
      DatabaseEvent event = await _databaseReference.child(path).once();
      dynamic value = event.snapshot.value;

      // Check if value is not null and is of the expected type
      if (value != null && value is Map<String, dynamic>) {
        print('Data read successfully');
        return value;
      } else {
        print('Error reading data: Unexpected data type');
        return {};
      }
        } catch (e) {
      print('Error reading data: $e');
      return {};
    }
  }

  Future<void> updateData(String path, Map<String, dynamic> data) async {
    try {
      await _databaseReference.child(path).update(data);
      print('Data updated successfully');
    } catch (e) {
      print('Error updating data: $e');
    }
  }

  Future<void> deleteData(String path) async {
    try {
      await _databaseReference.child(path).remove();
      print('Data deleted successfully');
    } catch (e) {
      print('Error deleting data: $e');
    }
  }

  Future<bool> addKeyValuePair(String path, String key, dynamic value) async {
    try {
      await _databaseReference.child(path).child(key).set(value);
      print('Key-value pair added successfully');
      return true;
    } catch (e) {
      print('Error adding key-value pair: $e');
      return false;
    }
  }
}
