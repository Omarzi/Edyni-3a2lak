import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/utils/constant.dart';

import '../providers/questions_provider.dart';
import '../widget/show_loading.dart';

class AdManager {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS ? "ca-app-pub-3940256099942544/2934735716" : "ca-app-pub-5889463199330557/6911064721",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    _bannerAd?.load();
  }

  Future loadRewardedAd()async {
    // real unit id we will use it after push to stores andriod 'ca-app-pub-2475932820776844/4040680846'
    // real unit id we will use it after push to stores ios 'ca-app-pub-2475932820776844/7365682337'

    try{
       await RewardedAd.load(
           adUnitId:Platform.isIOS ? "ca-app-pub-2475932820776844/7365682337" :"ca-app-pub-5889463199330557/7993401475",
         request: const AdRequest(),
         rewardedAdLoadCallback: RewardedAdLoadCallback(
           onAdLoaded: (ad) {
             ad.fullScreenContentCallback = FullScreenContentCallback(
               onAdDismissedFullScreenContent: (ad) {
                   ad.dispose();
                   _rewardedAd = null;
                   loadRewardedAd();
               },
             );
             log('ad is loaded ');
             _rewardedAd = ad;
           },
           onAdFailedToLoad: (err) {
             debugPrint('Failed to load a rewarded ad: ${err.message}');
           },
         ),

      );
    }
        catch(e){
      debugMessage(e.toString());
        }
  }

  void loadInterstitialAd() {
    String interstitialAdId = Platform.isIOS ? "ca-app-pub-3940256099942544/4411468910" : "ca-app-pub-3940256099942544/1033173712";

    InterstitialAd.load(
        adUnitId: interstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                loadInterstitialAd();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                ad.dispose();
                loadInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        )
    );
  }

  void addAds(bool interstitial, bool bannerAd, bool rewardedAd) {
    if (interstitial) {
      loadInterstitialAd();
    }

    if (bannerAd) {
      loadBannerAd();
    }

    if (rewardedAd) {
      loadRewardedAd();
    }
  }

  void showInterstitial() {
    _interstitialAd?.show();
  }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  void showRewardedAd(context) {
    if (_rewardedAd != null) {

      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedAd ad) {

            print("Ad onAdShowedFullScreenContent");
          },
          onAdDismissedFullScreenContent: (RewardedAd ad) {
            ad.dispose();
            loadRewardedAd();
          },

          onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
            debugMessage('errorrrr ->>> ${error.message}');
            ad.dispose();
            loadRewardedAd();
          }
      );

      //_rewardedAd!.setImmersiveMode(true);
      _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print("${reward.amount} ${reward.type}");
      },

      );
    }
  }

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}