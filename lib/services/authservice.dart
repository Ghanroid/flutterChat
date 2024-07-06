import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;
  User? get user {
    return _user;
  }

  Authservice() {
    _firebaseAuth.authStateChanges().listen(authStateChangelistener);
  }
  void authStateChangelistener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
