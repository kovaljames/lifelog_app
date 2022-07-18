import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lifelog_app/user.dart';

class LoginController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future socialLogin() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final User? firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      return;
    }

    var token = await firebaseUser.getIdToken();

    user.name = firebaseUser.displayName!;
    user.email = firebaseUser.email!;
    user.picture = firebaseUser.photoURL!;
    user.token = token;
  }

  Future login(String email, String password) async {
    final AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    final User? firebaseUser =
        (await _auth.signInWithCredential(credential)).user;
    if (firebaseUser == null) {
      return;
    }

    var token = await firebaseUser.getIdToken();

    user.name =
        firebaseUser.displayName != null ? firebaseUser.displayName! : "";
    user.email = firebaseUser.email!;
    user.picture = firebaseUser.photoURL != null
        ? firebaseUser.displayName!
        : "https://avatars.githubusercontent.com/u/105296759?s=40&v=4";
    user.token = token;
  }

  Future register(String email, String password) async {
    final User? firebaseUser = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (firebaseUser == null) {
      return;
    }

    await firebaseUser.sendEmailVerification();
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    user = IUser();
  }
}
