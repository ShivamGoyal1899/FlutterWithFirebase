import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHome extends StatefulWidget {
  @override
  _FirebaseHomeState createState() => _FirebaseHomeState();
}

class _FirebaseHomeState extends State<FirebaseHome> {

  final DocumentReference = Firestore.instance.document("myData/dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    print("User Name: ${user.displayName}");
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase With Flutter"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () =>
                  _signIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
              child: Text("Sign In"),
              color: Colors.green,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
              color: Colors.red,
            ),Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
              color: Colors.red,
            ),Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
              color: Colors.red,
            ),Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text("Sign Out"),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
