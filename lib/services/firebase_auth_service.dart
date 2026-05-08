import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Email/password diye sign in
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Login error: কোনো user পাওয়া যায়নি।');
      } else if (e.code == 'wrong-password') {
        print('Login error: পাসওয়ার্ড ভুল।');
      } else {
        print('Login error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  /// New user register korte
  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Register error: পাসওয়ার্ড খুব দুর্বল।');
      } else if (e.code == 'email-already-in-use') {
        print('Register error: এই email আগে থেকেই registered।');
      } else {
        print('Register error: ${e.message}');
      }
      return null;
    } catch (e) {
      print('Register error: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Sign out সফল হয়েছে।');
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  /// Current logged in user
  User? get currentUser {
    return _auth.currentUser;
  }

  /// Auth state changes listen korte (login/logout detect)
  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }
}