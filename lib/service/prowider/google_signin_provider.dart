import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider with ChangeNotifier {
  // object
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  // function for login
  login() async {
    googleSignInAccount = await _googleSignIn.signIn();

    // call
    notifyListeners();
  }

  // function to logout
  
}