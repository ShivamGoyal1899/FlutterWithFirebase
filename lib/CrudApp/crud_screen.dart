import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  String myName = null;
  String myDesc = null;

  StreamSubscription<DocumentSnapshot> subscription;

  final DocumentReference documentReference =
      Firestore.instance.collection("myData").document("dummy");

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

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
      myName = null;
      myDesc = null;
    }).catchError((e) => print(e));
  }

  void _fetch() {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        setState(() {
          myName = datasnapshot.data['name'];
          myDesc = datasnapshot.data['desc'];
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
          myName = datasnapshot.data['name'];
          myDesc = datasnapshot.data['desc'];
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    myName = null;
    myDesc = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: _add,
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Text(
                  "Add",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: _update,
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: _delete,
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              elevation: 4.0,
              onPressed: _fetch,
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Text(
                  "Fetch",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
            ),
            myName != null
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      '$myName | $myDesc',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Text(' '),
          ],
        ),
      ),
    );
  }
}
