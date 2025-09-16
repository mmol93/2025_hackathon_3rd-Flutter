import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  LoginRepository(this._auth);

  Future<void> signInWithGoogle() async {
    try {
      await _forceGoogleSignOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('ログインに失敗しました。');

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } catch (e) {
      await _forceGoogleSignOut();
      throw Exception('ログインに失敗しました。');
    }
  }

  Future<void> signOut() async {
    try {
      await _forceGoogleSignOut();
      await _auth.signOut();
    } catch (e) {
      throw Exception('ログアウト失敗');
    }
  }

  Future<void> _forceGoogleSignOut() async {
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }

      try {
        await _googleSignIn.disconnect();
      } catch (e) {}

      if (_googleSignIn.currentUser != null) {
        try {
          await _googleSignIn.signOut();
          await _googleSignIn.disconnect();
        } catch (e) {}
      }
    } catch (e) {}
  }
}
