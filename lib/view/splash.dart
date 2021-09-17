import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:maksid_dictionaty/model/todayword.dart';
import 'package:maksid_dictionaty/service/words-services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import '../const/const.dart';
import 'home.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPreferences prefs;
  fun() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("last") == null) {
      await WordApi.fetchSurList();
      prefs.setString("last", DateTime.now().toString());
    } else {
      if (DateTime.now()
              .difference(DateTime.parse(prefs.getString("last")))
              .inDays >=
          1) {
        await WordApi.fetchSurList();
        prefs.setString("last", DateTime.now().toString());
      } else {}
    }
  }

  Todayword todayword;
  fetchTodayword() async {
    print("fr called");
    try {
      var url = 'https://maksid.com/mobapp/getwod.php?j=g';
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      print(extractedData);
      if (extractedData != null) {
        print("id enter");
        todayword = Todayword.fromJson(extractedData);
        prefs.setInt("id", todayword.id);
      } else {}
    } catch (e) {
      print(e);
      return null;
    }
  }

  todaywordcheck() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getString("todaycheck") == null) {
      fetchTodayword();
      prefs.setString("todaycheck", DateTime.now().toString());
    } else {
      DateTime d = DateTime.now(),
          old = DateTime.parse(prefs.getString("todaycheck"));
      if (d.year > old.year || d.month > old.month || d.day > old.day) {
        fetchTodayword();
        prefs.setString("todaycheck", DateTime.now().toString());
      } else {}
    }
  }

  @override
  void initState() {
    fun();
    todaywordcheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        home: home(),
        duration: 6500,
        imageSize: 150,
        textType: TextType.ColorizeAnimationText,
        imageSrc: "assets/img/logo.png",
        text: "Maksid Dictionary",
        colors: [
          kPrimaryColor,
          Colors.white,
          kPrimaryColor.withOpacity(0.5),
        ],
      ),
    );
  }
}
