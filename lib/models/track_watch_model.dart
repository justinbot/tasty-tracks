import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final Firestore _firestore = Firestore.instance;

class TrackWatchModel extends Model {
  TrackWatchModel({
    this.user,
  });

  final FirebaseUser user;

  static const String collectionPath = 'track_watches';

  CollectionReference collection() {
    return _firestore.collection(collectionPath);
  }

  // TODO this doesn't really work like a scoped model
  // ScopedModelDescendants should have rebuildOnChange false
  Stream<QuerySnapshot> snapshots({String trackId}) {
    if (trackId != null) {
      return collection()
          .where('user_id', isEqualTo: user.uid)
          .where('track_id', isEqualTo: trackId)
          .snapshots();
    } else {
      return collection().where('user_id', isEqualTo: user.uid).snapshots();
    }
  }

  Future<DocumentSnapshot> get(String trackId) async {
    QuerySnapshot query = await _firestore
        .collection(collectionPath)
        .where('user_id', isEqualTo: user.uid)
        .where('track_id', isEqualTo: trackId)
        .getDocuments();

    if (query.documents.isEmpty) {
      return null;
    } else {
      return query.documents.first;
    }
  }

  Future<QuerySnapshot> getAll() async {
    return _firestore
        .collection(collectionPath)
        .where('user_id', isEqualTo: user.uid)
        .getDocuments();
  }

  Future<DocumentReference> add(String trackId) async {
    FirebaseUser user = await _auth.currentUser();
    // TODO Run query and write in same transaction
    QuerySnapshot query = await collection()
        .where('user_id', isEqualTo: user.uid)
        .where('track_id', isEqualTo: trackId)
        .getDocuments();
    // Don't allow multiple watches for one track
    if (query.documents.isEmpty) {
      // Return reference to the newly added watch
      DocumentReference reference = await collection().add({
        'user_id': user.uid,
        'created_timestamp': FieldValue.serverTimestamp(),
        'track_id': trackId,
      });
      notifyListeners();
      return reference;
    } else {
      return null;
    }
  }

  Future<void> remove(String trackId) async {
    // TODO Run query and write in same transaction
    QuerySnapshot query = await collection()
        .where('user_id', isEqualTo: user.uid)
        .where('track_id', isEqualTo: trackId)
        .getDocuments();
    if (query.documents.isNotEmpty) {
      await query.documents.first.reference.delete();
      notifyListeners();
    }
  }
}
