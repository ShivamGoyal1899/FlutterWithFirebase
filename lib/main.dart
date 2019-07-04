import 'package:flutter/material.dart';
import 'firebaseHome.dart';

void main() => runApp(FirebaseApp());

class FirebaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FirebaseWithFlutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirebaseHome(),
    );
  }
}