import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:maksid_dictionaty/model/words.dart';
import 'package:maksid_dictionaty/model/wordsLocalDataBase.dart';
import 'package:maksid_dictionaty/view/search-screen.dart';
import 'package:maksid_dictionaty/view/view-categorywords/viewcategory.dart';
import 'package:maksid_dictionaty/view/view-favorite/favorite.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../const/const.dart';
import '../functios.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<DropdownMenuItem> item = [];
  List<WordModel> wordlist;
  String applung = "", tralung = "";
  SharedPreferences prefs;
  WordModel Tword;
  Future<void> _getBool() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs.getString("applung") == null) {
      prefs.setString("applung", "en");
      applung = "en";
      Get.updateLocale(Locale('en'));
    } else {
      applung = prefs.getString("applung");
      if (applung == "ar")
        Get.updateLocale(Locale('ar'));
      else if (applung == "en")
        Get.updateLocale(Locale('en'));
      else
        Get.updateLocale(Locale('tr'));
    }
    if (prefs.getString("tralung") == null) {
      prefs.setString("tralung", "ar");
      tralung = "ar";
    } else {
      tralung = prefs.getString("tralung");
    }
  }

  int todayid;

  GetAllWords() async {
    wordlist = await WordModel_service_database().getWordModel();
    List<DropdownMenuItem> item2 = [];
    for (int i = 0; i < wordlist.length; i++) {
      item2.add(
        DropdownMenuItem(
          child: Container(
            width: double.infinity,
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(wordlist[i])));
                },
                child: Text(
                  wordlist[i].entryWithHarakat,
                  style: GoogleFonts.almarai(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                )),
          ),
          value: wordlist[i].entry + wordlist[i].eng,
          onTap: () {},
        ),
      );
    }
    setState(() {
      item = item2;
    });
  }

  fetchTodayword() async {
    prefs = await SharedPreferences.getInstance();
    todayid = await prefs.getInt("id");
    print(todayid);
    if (todayid != null) {
      Tword = await WordModel_service_database().find(todayid);
      setState(() {
        Tword = Tword;
      });
    }
  }

  @override
  void initState() {
    GetAllWords();
    _getBool();
    fetchTodayword();
  }

  @override
  Widget build(BuildContext context) {
    var dio = Dio();

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/img/bg1-2.jpg"), fit: BoxFit.cover),
          ),
          child: tralung == ""
              ? SpinKitWave(
                  color: kPrimaryColor,
                  size: 50.0,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 150.h,
                        child: Image(
                          image: AssetImage("assets/img/logo.png"),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.purple),
                            borderRadius: BorderRadius.circular(25)),
                        child: SearchableDropdown.single(
                          underline: Padding(
                            padding: EdgeInsets.all(5.h),
                          ),
                          value: "selectedValue",
                          dialogBox: true,
                          searchHint: Center(
                            child: Text(
                              "Select one",
                              style: style(Get.locale.toString(), 15,
                                  FontWeight.w400, Colors.black),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                          isExpanded: true,
                          hint: "search".tr,
                          items: item,
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Today's Word".tr,
                        style: style(Get.locale.toString(), 19.sp,
                            FontWeight.w400, Colors.black),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.h),
                        width: double.infinity,
                        height: 120.h,
                        margin: EdgeInsets.all(10.h),
                        decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(28.sp)),
                        child: Tword == null
                            ? Center(child: Text("loading..."))
                            : Stack(
                                children: [
                                  IconButton(
                                      icon: Icon(
                                        Icons.play_circle_fill_outlined,
                                        size: 30.r,
                                      ),
                                      onPressed: () {
                                        play(Tword.audioFile);
                                      }),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SearchScreen(Tword)));
                                    },
                                    child: Center(
                                        child: Text(
                                      Tword.entryWithHarakat,
                                      style: style(Get.locale.toString(), 29.sp,
                                          FontWeight.w500, Colors.black),
                                    )),
                                  ),
                                ],
                              ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => favoirte()));
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              margin: EdgeInsets.all(10.h),
                              padding: EdgeInsets.all(10.h),
                              decoration: containerdecoration(
                                  kPrimaryColor, kPrimaryColor, 20.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "fav".tr,
                                    style: style(Get.locale.toString(), 17.sp,
                                        FontWeight.w400, Colors.white),
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 25.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WordCategory()));
                            },
                            child: Container(
                              height: 50.h,
                              width: 150.w,
                              margin: EdgeInsets.all(10.h),
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                  border: Border.all(color: kPrimaryColor),
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(20.sp)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "My Words".tr,
                                    style: style(Get.locale.toString(), 17.sp,
                                        FontWeight.w400, Colors.white),
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 25.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      //setting
                      ExpansionTile(
                        title: Row(
                          children: [
                            Text(
                              "Settings".tr,
                              style: style(Get.locale.toString(), 22.sp,
                                  FontWeight.w400, Colors.black),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Icon(
                              Icons.settings,
                              color: kPrimaryColor,
                            )
                          ],
                        ),
                        children: [
                          Container(
                            height: 0.22.sh,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    //crossAxisAlignment:Get.locale.toString()=='ar'?CrossAxisAlignment.start:CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 35.h,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                        ),
                                        child: Text(
                                          "App Language".tr,
                                          textAlign:
                                              Get.locale.toString() == 'ar'
                                                  ? TextAlign.right
                                                  : TextAlign.start,
                                          style: GoogleFonts.almarai(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        height: 50.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "applung", "ar");
                                                  Get.updateLocale(
                                                      Locale('ar'));
                                                },
                                                child: cont(
                                                    'العربيه',
                                                    Get.locale.toString() ==
                                                            'ar'
                                                        ? true
                                                        : false)),
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "applung", "en");
                                                  Get.updateLocale(
                                                      Locale('en'));
                                                },
                                                child: cont(
                                                    'English',
                                                    Get.locale.toString() ==
                                                            'en'
                                                        ? true
                                                        : false)),
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "applung", "tr");
                                                  Get.updateLocale(
                                                      Locale('tr'));
                                                },
                                                child: cont(
                                                    'Türkçe',
                                                    Get.locale.toString() ==
                                                            'tr'
                                                        ? true
                                                        : false)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 35.h,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                        ),
                                        child: Text(
                                          "translation Language".tr,
                                          style: GoogleFonts.almarai(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 5.h,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "tralung", "ar");
                                                  setState(() {
                                                    tralung = "ar";
                                                  });
                                                },
                                                child: cont(
                                                    'العربيه',
                                                    tralung == 'ar'
                                                        ? true
                                                        : false)),
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "tralung", "en");
                                                  setState(() {
                                                    tralung = "en";
                                                  });
                                                },
                                                child: cont(
                                                    'English',
                                                    tralung == 'en'
                                                        ? true
                                                        : false)),
                                            GestureDetector(
                                                onTap: () {
                                                  prefs.setString(
                                                      "tralung", "tr");
                                                  setState(() {
                                                    tralung = "tr";
                                                  });
                                                },
                                                child: cont(
                                                    'Turkce',
                                                    tralung == 'tr'
                                                        ? true
                                                        : false)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
