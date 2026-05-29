import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_aplicattion/pages/login_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signOutGoogleAndNavigateToLogin(BuildContext context) async {
  try {
    await _googleSignIn.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eroare la deconectare: $e')),
      );
    }
  }
}