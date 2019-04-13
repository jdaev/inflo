import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInChecker {
  Future loginStatus(String uid) async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.isNotEmpty) {
      return result.documents[0]['name'];
    } else {
      return null;
    }
  }
  Future<bool> isLoggedIn() async {
    bool login;
    FirebaseAuth.instance.currentUser().then((user) => user != null ? login = true : login = false );
    return login;
  }
}
