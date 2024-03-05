import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference data =
      FirebaseFirestore.instance.collection('users');

//Creating user
  Future<void> addUser(
      String name, String phoneNumber, String email, String role) {
    return data.add({
      'Name': name,
      'Phone Number ': phoneNumber,
      'Email': email,
      'Role': role
    });
  }

//Deleteing the user
  Future<void> deleteUser(String docId) {
    return data.doc(docId).delete();
  }
}
