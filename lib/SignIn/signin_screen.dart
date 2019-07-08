import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static String myPhoto = ' ';
  var bigPhoto = myPhoto.replaceAll('96', '512');
  String myName = ' ';
  String myEmail = ' ';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> _googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    myPhoto = user.photoUrl;
    bigPhoto = myPhoto.replaceAll('96', '512');
    myName = user.displayName;
    myEmail = user.email;
    setState(() {});

    print("User Name: ${user.displayName}");
    return user;
  }

  void _googleSignOut() {
    googleSignIn.signOut();
    setState(() {});
    myPhoto = ' ';
    myName = ' ';
    myEmail = ' ';
    print("User Signed Out");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            myName == ' '
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: () {
                      return _googleSignIn()
                          .then((FirebaseUser user) => print(user));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    color: Colors.white,
                  )
                : RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 4.0,
                    onPressed: _googleSignOut,
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    color: Colors.white,
                  ),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 40.0),
                child: Container(
                  child: myName != ' '
                      ? Column(
                          children: <Widget>[
                            Image.network(
                              '$bigPhoto',
                              scale: 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                myName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                myEmail,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: 200.0,
                          alignment: Alignment.center,
                          child: Text(
                            'Sign In to get details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
