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
  String myText = null;

  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
  Firestore.instance.collection("myData").document("dummy");

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

  void _add() {
    Map<String, String> data = <String, String>{
      "name": "Shivam",
      "desc": "Flutter Developer",
    };

    documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void _update() {
    Map<String, String> data = <String, String>{
      "name": "ShyVum",
      "desc": "ML Engineer",
    };

    documentReference.updateData(data).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

  void _delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
      setState(() {});
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    subscription = documentReference.snapshots.listen((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myText = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
//      setState(() {
        myText = null;
//      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Flutter With Firebase"),
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                onPressed: () =>
                    _signIn()
                        .then((FirebaseUser user) => print(user))
                        .catchError((e) => print(e)),
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
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              RaisedButton(
                onPressed: _add,
                child: Text("Add"),
                color: Colors.cyan,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              RaisedButton(
                onPressed: _update,
                child: Text("Update"),
                color: Colors.lightBlue,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              RaisedButton(
                onPressed: _delete,
                child: Text("Delete"),
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              RaisedButton(
                onPressed: _fetch,
                child: Text("Fetch"),
                color: Colors.lime,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              Center(
                child: myText == null
                    ? Container()
                    : Text(
                  myText,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
