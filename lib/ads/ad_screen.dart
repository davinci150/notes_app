import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'ad_state.dart';

/*class AdMob extends StatefulWidget {
  const AdMob({Key key}) : super(key: key);

  @override
  _AdMobState createState() => _AdMobState();
}

class _AdMobState extends State<AdMob> {
  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((value) {
      setState(() {
        banner = BannerAd(
          adUnitId: adState.bannerAdUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: adState.adListener,
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMOB'),
      ),
      body: SizedBox(
        height: 50,
        child: AdWidget(
          ad: banner,
        ),
      ),
    );
  }
}
*/