import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'fullscreen_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class WallScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  WallScreen({this.analytics, this.observer});

  @override
  _WallScreenState createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  static final MobileAdTargetingInfo targetInfo = MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    birthday: DateTime.now(),
    childDirected: true,
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  StreamSubscription<QuerySnapshot> subscription;

  List<DocumentSnapshot> wallpapersList;

  final CollectionReference collectionReference =
      Firestore.instance.collection("wallpapers");

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event: $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: InterstitialAd.testAdUnitId,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event: $event");
        });
  }

  Future<Null> _currentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName: 'WallScreen', screenClassOverride: 'WallScreen');
  }

  Future<Null> _sendAnalytics() async {
    await widget.analytics
        .logEvent(name: 'tap to full screen', parameters: <String, dynamic>{});
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()
      ..load()
      ..show(anchorOffset: 50.0);
    subscription = collectionReference.snapshots.listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    _currentScreen();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallpapersList != null
          ? StaggeredGridView.countBuilder(
              padding: EdgeInsets.all(8.0),
              crossAxisCount: 4,
              itemCount: wallpapersList.length,
              itemBuilder: (context, i) {
                String imgPath = wallpapersList[i].data['url'];
                return Material(
                  elevation: 8.0,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      _sendAnalytics();
                      createInterstitialAd()
                        ..load()
                        ..show();
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImagePage(imgPath),
                        ),
                      );
                    },
                    child: Hero(
                      tag: imgPath,
                      child: FadeInImage(
                        placeholder:
                            AssetImage("assets/images/fadeinimage.jpg"),
                        image: NetworkImage(imgPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
              staggeredTileBuilder: (i) =>
                  StaggeredTile.count(2, i.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
