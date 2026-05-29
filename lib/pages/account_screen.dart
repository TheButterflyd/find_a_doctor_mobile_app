import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:doctor_aplicattion/pages/login_page.dart';
import 'package:doctor_aplicattion/components/google_signout.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _currentUser == null
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Nu ești logat', style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text('Mergi la Login'),
                    ),
                  ],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bun venit, ${_currentUser!.displayName ?? 'Utilizator'}',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentUser!.email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        signOutGoogleAndNavigateToLogin(context);
                      },

                      child: const Text('Deconecteaza-te'),
                    ),
                  ],
                ),
      ),
    );
  }
}
