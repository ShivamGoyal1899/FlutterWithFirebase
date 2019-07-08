import 'package:flutter/material.dart';
import 'SignIn/signin_screen.dart';
import 'WallpaperApp/wall_screen.dart';
import 'CrudApp/crud_screen.dart';

void main() => runApp(FirebaseApp());

class FirebaseApp extends StatefulWidget {
  @override
  _FirebaseAppState createState() => _FirebaseAppState();
}

class _FirebaseAppState extends State<FirebaseApp> {
  PageController _myPage = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FirebaseWithFlutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 4.0,
            title: Text(
              'Flutter With Firebase',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        body: PageView(
          controller: _myPage,
          children: <Widget>[
            Center(
              child: Container(
                child: SignInScreen(),
              ),
            ),
            Center(
              child: Container(
                child: CrudScreen(),
              ),
            ),
            Center(
              child: Container(
                child: WallScreen(),
              ),
            ),
          ],
          physics:
              NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          height: 50.0,
          alignment: Alignment.topCenter,
          child: BottomAppBar(
            elevation: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  highlightColor: Colors.transparent,
                  highlightElevation: 0.0,
                  elevation: 0.0,
                  onPressed: () {
                    setState(() {
                      _myPage.jumpToPage(0);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text(
                      "G SignIn",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  color: Colors.white,
                ),
                RaisedButton(
                  highlightColor: Colors.transparent,
                  highlightElevation: 0.0,
                  elevation: 0.0,
                  onPressed: () {
                    setState(() {
                      _myPage.jumpToPage(1);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text(
                      "CRUD Ops",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  color: Colors.white,
                ),
                RaisedButton(
                  highlightColor: Colors.transparent,
                  highlightElevation: 0.0,
                  elevation: 0.0,
                  onPressed: () {
                    setState(() {
                      _myPage.jumpToPage(2);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    child: Text(
                      "AdMob",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
