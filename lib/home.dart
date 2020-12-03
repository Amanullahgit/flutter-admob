import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import 'next_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();
  int _coins = 0;
  final _nativeAdController = NativeAdmobController();
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: InterstitialAd.testAdUnitId,
        listener: (MobileAdEvent event) {
          print('interstitial event: $event');
        });
  }

  BannerAd createBannerAdd() {
    return BannerAd(
        targetingInfo: targetingInfo,
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        listener: (MobileAdEvent event) {
          print('Bnner Event: $event');
        });
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 10), () {
      _bannerAd?.show();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _bannerAd?.dispose();
                _bannerAd = null;
                _interstitialAd?.show();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => NextPage()));
              }),
          IconButton(
              icon: Icon(Icons.video_call),
              onPressed: () async {
                _bannerAd?.dispose();
                _bannerAd = null;
                await RewardedVideoAd.instance.show();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NextPage(
                          coins: _coins,
                        )));
              }),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.all(8),
              color: Colors.blue,
              height: 200,
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ));
        },
        separatorBuilder: (context, index) {
          return index % 4 == 0
              ? Container(
                  margin: EdgeInsets.all(8),
                  height: 200,
                  color: Colors.green,
                  child: NativeAdmob(
                    adUnitID: NativeAd.testAdUnitId,
                    controller: _nativeAdController,
                    type: NativeAdmobType.full,
                    loading: Center(child: CircularProgressIndicator()),
                    error: Text('failed to load'),
                  ))
              : Container();
        },
        itemCount: 20,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: 'YOUR_APP_ID');
    _bannerAd = createBannerAdd()..load();
    _interstitialAd = createInterstitialAd()..load();
    RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print('Rewarded event: $event');
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
    };
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }
}
