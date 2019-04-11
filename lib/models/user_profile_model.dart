import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

class UserProfileModel extends Model {
  UserProfileModel({
    this.user,
  });

  final FirebaseUser user;

  static const String collectionPath = 'user_profiles';

  CollectionReference collection() {
    return _firestore.collection(collectionPath);
  }

  /// Note: ScopedModelDescendants should use rebuildOnChange=false with streams.
  Stream<QuerySnapshot> snapshots() {
    Query query = collection().where('user_id', isEqualTo: user.uid);
    return query.snapshots();
  }

  Future<DocumentReference> create(String username) async {
    // TODO Run query and write in same transaction
    QuerySnapshot query =
        await collection().where('user_id', isEqualTo: user.uid).getDocuments();
    // Don't allow multiple user profiles
    if (query.documents.isEmpty) {
      // Return reference to the newly added profile
      DocumentReference reference = await collection().add({
        'created_timestamp': FieldValue.serverTimestamp(),
        'user_id': user.uid,
        'username': username,
        'balance': 0.0,
      });
      notifyListeners();
      return reference;
    } else {
      return null;
    }
  }

  Future<DocumentSnapshot> get() async {
    QuerySnapshot query = await _firestore
        .collection(collectionPath)
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();

    if (query.documents.isEmpty) {
      return null;
    } else {
      return query.documents.first;
    }
  }

  Future<DocumentReference> update({String username, double balance}) async {
    QuerySnapshot query = await _firestore
        .collection(collectionPath)
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();

    if (query.documents.isEmpty) {
      return null;
    } else {
      DocumentSnapshot userProfile = query.documents.first;

      Map<String, dynamic> update = Map();

      if (username != null) {
        update['username'] = username;
      }
      if (balance != null) {
        update['balance'] = balance;
      }

      await userProfile.reference.updateData(update);
      notifyListeners();

      return userProfile.reference;
    }
  }
}
