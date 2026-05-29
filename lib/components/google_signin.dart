import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print('Autentificare anulată de utilizator');
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;

    // Dacă utilizatorul e nou, salvează în Firestore
    if (userCredential.additionalUserInfo?.isNewUser ?? false) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
            'name': user.displayName,
            'email': user.email,
            'photoUrl': user.photoURL,
            'createdAt': Timestamp.now(),
          });
    }

    return user;
  } catch (e) {
    print('Eroare Google Sign-In: $e');
    return null;
  }
}
