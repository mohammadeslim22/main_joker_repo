import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';

class LoadAboutUs extends StatelessWidget {
  const LoadAboutUs({Key key, this.appName, this.appVersion}) : super(key: key);
  final String appName;
  final String appVersion;
  Future<String> getAboutUs() async {
    final Response<dynamic> response = await dio.get<dynamic>("privacy");
    return response.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String>(
        future: getAboutUs(),
        builder: (BuildContext ctx, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AboutUs(
                appName: appName, appVersion: appVersion, about: snapshot.data);
          } else {
            return Container(
              color: colors.white,
              child: const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(radius: 24),
              ),
            );
          }
        },
      ),
    );
  }
}

class AboutUs extends StatelessWidget {
  const AboutUs({Key key, this.appName, this.appVersion, this.about})
      : super(key: key);
  final String appName;
  final String appVersion;
  final String about;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, 'about_us'), style: styles.appBars),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(appName, style: styles.mystyle2),
            const SizedBox(height: 10),
            Text(
              about,
              softWrap: true,
              style: styles.mystyle,
            ),
            Center(
              child: SvgPicture.asset("assets/images/joker_indirim.svg",
                  width: 120.0, height: 120.0),
            ),
            // Center(
            //   child: SvgPicture.asset(
            //     'assets/images/logo.svg',
            //     width: 120.0,
            //     height: 120.0,
            //   ),
            // ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "",
                  style: TextStyle(color: colors.red),
                ),
                Text(appVersion)
              ],
            ),
            const SizedBox(height: 12)
          ],
        ),
      ),
    );
  }
}
