import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'home.dart';
import 'login.dart';

class AuthenticationProvider {
  final FirebaseAuth firebaseAuth;
  final _googleSignIn = GoogleSignIn();
  //FirebaseAuth instance
  AuthenticationProvider(this.firebaseAuth);
  //Constructor to initialize the FirebaseAuth instance

  //Using Stream to listen to Authentication State
  Stream<User> get authState => firebaseAuth.idTokenChanges();

  //SIGN UP METHOD
  Future<String> signUp({String email, String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future<String> signIn({String email, String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in!";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, s) {
      debugPrint('google signIn failed: $e. $s');
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Instance to know the authentication state.
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      //Means that the user is logged in already and hence navigate to HomePage
      return HomePage();
    }
    //The user isn't logged in and hence navigate to SignInPage.
    return LogInPage();
  }
}