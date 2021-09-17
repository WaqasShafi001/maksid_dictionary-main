import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maksid_dictionaty/model/words.dart';
import 'package:maksid_dictionaty/model/wordsLocalDataBase.dart';
import 'package:maksid_dictionaty/service/share.dart';
import 'package:maksid_dictionaty/service/words-services.dart';
import 'package:maksid_dictionaty/view/view-categorywords/viewcategory.dart';
import 'package:maksid_dictionaty/view/view-favorite/favorite-viewmodel.dart';
import 'package:maksid_dictionaty/view/view-favorite/favorite.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../const/const.dart';
import '../functios.dart';
import 'home.dart';

class SearchScreen extends StatefulWidget {
  final WordModel word;
  SearchScreen(@required this.word);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Widget> conj = [];
  List<DropdownMenuItem> item = [];
  List<DropdownMenuItem> categories = [];
  List<WordModel> wordlist = [];
  String dropval = "1";
  List<Widget> Collocations = [];
  List<Map> allCategories = [];
  String lung = Get.locale.toString();
  bool oppG = false;
  List pronouns = [
    'I',
    'you_male',
    'you_female',
    'he',
    'she',
    'they_2_male',
    'they_2_female',
    'they',
    'they_female',
    'you_2',
    'you_all',
    'you_2_female',
    'we'
  ];
  List pronouns2 = [
    'you_male',
    'you_female',
    'you_2',
    'you_all',
    'they_female',
  ];
  List past;

  String imm() {
    if (widget.word.img != null || widget.word.img != "") {
      String im = widget.word.img.replaceAll("[", "");
      im = im.replaceAll("]", "");
      im = im.replaceAll("\"", "");
      List img = im.split(",");
      return "https://maksid.com/imgs/thumb/" + img[0];
    }
  }

  getconjvalue() {
    if (widget.word.sing != null && widget.word.sing != "")
      conj.add(rowofTxt("Sing".tr, widget.word.sing, lung));

    if (widget.word.du != null && widget.word.du != "")
      conj.add(rowofTxt("Dual".tr, widget.word.du, lung));

    if (widget.word.plu != null && widget.word.plu != "")
      conj.add(rowofTxt("Plural".tr, widget.word.plu, lung));

    if (widget.word.pluFem != null && widget.word.pluFem.trim() != "")
      conj.add(rowofTxt("pluFem".tr, widget.word.pluFem, lung));

    if (widget.word.root != null && widget.word.root != "")
      conj.add(rowofTxt("Root".tr, widget.word.root, lung));

    if (widget.word.kNoun != null && widget.word.kNoun != "")
      conj.add(rowofTxt("Verb Noun".tr, widget.word.kNoun, lung));

    if (widget.word.gerund != null && widget.word.gerund != "")
      conj.add(rowofTxt("gerund".tr, widget.word.gerund, lung));

    if (widget.word.plPlu != null && widget.word.plPlu != "")
      conj.add(rowofTxt("plPlu".tr, widget.word.plPlu, lung));

    if (widget.word.present != null && widget.word.present != "") {
      past = widget.word.present.split("|");
      print(past[0]);
      conj.add(Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
        child: Row(
          mainAxisAlignment:
              lung == 'ar' ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              "present".tr,
              style: style(lung, 17.sp, FontWeight.w600, kPrimaryColor),
            ),
          ],
        ),
      ));
      for (int i = 0; i < past.length; i++)
        conj.add(rowofTxt("${pronouns[i]}".tr, past[i], lung));
    }

    if (widget.word.past != null && widget.word.past != "") {
      past = widget.word.past.split("|");
      print(past[0]);
      conj.add(Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
        child: Row(
          mainAxisAlignment:
              lung == 'ar' ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              "past".tr,
              style: style(lung, 17.sp, FontWeight.w600, kPrimaryColor),
            ),
          ],
        ),
      ));
      for (int i = 0; i < past.length; i++)
        conj.add(rowofTxt("${pronouns[i]}".tr, past[i], lung));
    }

    if (widget.word.phrasesConjugations != null &&
        widget.word.phrasesConjugations != "") {
      past = widget.word.past.split("|");
      print(past[0]);
      conj.add(Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 15.h),
        child: Row(
          mainAxisAlignment:
              lung == 'ar' ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              "PhrasesConjugations".tr,
              style: style(lung, 17.sp, FontWeight.w600, kPrimaryColor),
            ),
          ],
        ),
      ));
      for (int i = 0; i < past.length; i++)
        conj.add(rowofTxt("${pronouns2[i]}".tr, past[i], lung));
    }

    if (widget.word.imperative != null && widget.word.imperative != "")
      conj.add(
          rowofTxt("PhrasesConjugations".tr, widget.word.imperative, lung));

    if (widget.word.comparative != null && widget.word.comparative != "")
      conj.add(rowofTxt("Comparative".tr, widget.word.comparative, lung));
  }

  getCollocationsvalue() {
    if (widget.word.plusNoun != null && widget.word.plusNoun != "")
      Collocations.add(rowofTxt("plusNoun".tr, widget.word.plusNoun, lung));

    if (widget.word.plusAdj != null && widget.word.plusAdj != "")
      Collocations.add(rowofTxt("plusAdj".tr, widget.word.plusAdj, lung));

    if (widget.word.plusPrep != null && widget.word.plusPrep != "")
      Collocations.add(rowofTxt("plusPrep".tr, widget.word.plusPrep, lung));

    if (widget.word.plusVerb != null && widget.word.plusVerb != "")
      Collocations.add(rowofTxt("plusVerb".tr, widget.word.plusVerb, lung));
  }

  Future GetAllWords() async {
    wordlist = await WordModel_service_database().getWordModel();
    List<DropdownMenuItem> item2 = [];
    for (int i = 0; i < wordlist.length; i++) {
      item2.add(
        DropdownMenuItem(
          child: Container(
            width: double.infinity,
            child: GestureDetector(
                onTap: () {},
                child: Text(
                  wordlist[i].entryWithHarakat,
                  style: GoogleFonts.almarai(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                )),
          ),
          value: wordlist[i].entry + wordlist[i].eng,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchScreen(wordlist[i])));
          },
        ),
      );
    }
    setState(() {
      item = item2;
    });
  }

  GetAllcategories() async {
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

  void getPermission() async {
    // await WordApi.fetchSurList();
    print("getPermission");
    if (Platform.isAndroid) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
    }
  }

  @override
  void initState() {
    GetAllWords().then((value) {
      wordlist.forEach((element) {
        log('iten = ${element.audioFile}');
      });

      log('==================================list ${wordlist.length}');
    });
    getPermission();
    getconjvalue();
    GetAllcategories();
    getCollocationsvalue();
  }

  String show = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => home()));
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/img/bg1-2.jpg"), fit: BoxFit.cover),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => home()));
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.h),
                            padding: EdgeInsets.all(5.h),
                            decoration: containerdecoration(
                                kPrimaryColor, kPrimaryColor, 20.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Home".tr,
                                  style: style(lung, 17.sp, FontWeight.w500,
                                      Colors.white),
                                ),
                                Icon(
                                  Icons.home,
                                  color: Colors.white,
                                  size: 15.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Get.to(favoirte(
                              word: widget.word,
                            ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.h),
                            margin: EdgeInsets.all(5.h),
                            decoration: containerdecoration(
                                kPrimaryColor, kPrimaryColor, 30.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "fav".tr,
                                  style: style(lung, 17.sp, FontWeight.w500,
                                      Colors.white),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                  size: 15.r,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Get.to(WordCategory());
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.h),
                            margin: EdgeInsets.all(5.h),
                            decoration: containerdecoration(
                                kPrimaryColor, kPrimaryColor, 20.sp),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "My Words".tr,
                                    style: style(lung, 17.sp, FontWeight.w500,
                                        Colors.white),
                                  ),
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 15.r,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 37.h,
                        child: Image(
                          image: AssetImage("assets/img/logo.png"),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purple),
                        borderRadius: BorderRadius.circular(25)),
                    child: SearchableDropdown.single(
                      underline: Padding(
                        padding: EdgeInsets.all(5.h),
                      ),
                      value: "selectedValue",
                      dialogBox: true,
                      searchHint: "Select one",
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
                  //icons Row for like or share
                  Container(
                    width: 170.w,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.share,
                              size: 28.r,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              shareWord(widget.word.entryWithHarakat);
                            }),
                        IconButton(
                            icon: Icon(
                              widget.word.fav == 1
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 28.r,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                widget.word.fav = widget.word.fav == 0 ? 1 : 0;
                              });
                              WordProvider().updateWord(widget.word);
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              size: 28.r,
                              color: kPrimaryColor,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(40),
                                                topRight: Radius.circular(40))),
                                        backgroundColor: Colors.white,
                                        content: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter setState) {
                                          return Container(
                                            width: 400.w,
                                            height: 300.h,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Container(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text(
                                                        widget.word
                                                            .entryWithHarakat,
                                                        style: style(
                                                            "ar",
                                                            25.sp,
                                                            FontWeight.w600,
                                                            kPrimaryColor),
                                                      ),
                                                    ),
                                                    DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        items: categories,
                                                        hint: Text("selext"),
                                                        value: dropval,
                                                        isExpanded: true,
                                                        icon: Icon(Icons
                                                            .arrow_downward),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            dropval = val;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                        title: Center(
                                          child: Text(
                                            ' Add Word "'.tr +
                                                widget.word.entryWithHarakat +
                                                ' " to my words list'.tr,
                                            style: style(lung, 15.sp,
                                                FontWeight.w500, kPrimaryColor),
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: kPrimaryColor,
                                                        spreadRadius: .75,
                                                        blurRadius: 2,
                                                        offset: Offset(1, 1))
                                                  ],
                                                  border: Border.all(
                                                      color: kPrimaryColor),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: TextButton(
                                                child: Text(
                                                  'Select'.tr,
                                                  style: style(
                                                    lung,
                                                    17.sp,
                                                    FontWeight.w500,
                                                    Colors.black54,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (dropval != "1" &&
                                                      dropval != "2") {
                                                    widget.word.cat = dropval;

                                                    await WordModel_service_database()
                                                        .update(widget.word);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            })
                      ],
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.only(top: 10.h),
                    width: double.infinity,
                    height: 120.h,
                    margin: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(28.sp)),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            widget.word.entryWithHarakat,
                            style: style(
                                "ar", 40.sp, FontWeight.w400, Colors.black),
                          ),
                        ),
                        if (widget.word.img != null || widget.word.img != "")
                          Positioned(
                            right: 0,
                            child: Container(
                              height: 120.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                // border: Border.all(color: kPrimaryColor),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(28.sp),
                                    topRight: Radius.circular(28.sp)),
                                image: DecorationImage(
                                    image: NetworkImage(imm()),
                                    fit: BoxFit.cover),
                              ),
                              //  child: Image(image: NetworkImage(imm()),),
                            ),
                          ),
                      ],
                    ),
                  ),

                  //first details row
                  Row(
                    children: [
                      if (widget.word.poSpeech != "" &&
                          widget.word.poSpeech != null)
                        Container(
                          height: 38.h,
                          width: 70.w,
                          margin: EdgeInsets.only(left: 10.w),
                          decoration: containerdecoration(
                              kPrimaryColor, kPrimaryColor, 20.sp),
                          child: Center(
                            child: Text(
                              widget.word.poSpeech,
                              style: style(
                                  "ar", 15.sp, FontWeight.w500, Colors.white),
                            ),
                          ),
                        ),
                      if (widget.word.level != "" && widget.word.level != null)
                        Container(
                          height: 38.h,
                          margin: EdgeInsets.only(left: 10.w),
                          width: 70.w,
                          decoration: containerdecoration(
                              kPrimaryColor, kPrimaryColor, 19.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                convertlevel(widget.word.level),
                                style: style(
                                    "ar", 15.sp, FontWeight.w500, Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (widget.word.audioFile != "" &&
                          widget.word.audioFile != null)
                        IconButton(
                            icon: Icon(
                              Icons.play_circle_fill_outlined,
                              size: 40.r,
                              color: kPrimaryColor,
                            ),
                            onPressed: () async {
                              await play(widget.word.audioFile);
                              //play(widget.word.audioFile);
                            }),
                      if (widget.word.gender != "" &&
                          widget.word.gender != null)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              oppG = !oppG;
                            });
                          },
                          child: Image(
                            image: AssetImage(
                              widget.word.gender != 'ذ'
                                  ? "assets/malee.png"
                                  : "assets/femenine.png",
                            ),
                            width: 30.w,
                            height: 30.h,
                          ),
                        ),
                      if (widget.word.oppGender != "" &&
                          widget.word.oppGender != null &&
                          oppG == true)
                        Container(
                          padding: EdgeInsets.all(5.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: AssetImage(
                                  widget.word.gender == 'ذ'
                                      ? "assets/malee.png"
                                      : "assets/femenine.png",
                                ),
                                width: 20.w,
                                height: 20.h,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(widget.word.oppGender),
                            ],
                          ),
                        ),
                    ],
                  ),

                  //meaning
                  if (widget.word.meaning != "" && widget.word.meaning != null)
                    Padding(
                      padding: EdgeInsets.all(9.w),
                      child: Row(
                        mainAxisAlignment: Get.locale.toString() == 'ar'
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Flexible(
                            // flex: 0,
                            child: Text(
                              widget.word.meaning,
                              maxLines: 4,
                              style: style(
                                  "ar", 22, FontWeight.w400, Colors.black),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),

                  //examples
                  if (widget.word.examples != "" &&
                      widget.word.examples != null)
                    Container(
                      margin: EdgeInsets.all(10.h),
                      padding: EdgeInsets.only(right: 15.w),
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.black, width: 1.h)),
                      ),
                      child: Row(
                        mainAxisAlignment: Get.locale.toString() == 'ar'
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              widget.word.examples.replaceAll('|', "\n"),
                              style: style(
                                "ar",
                                19.sp,
                                FontWeight.w300,
                                Colors.black,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: 350.w,
                    height: 40.h,
                    child: Row(
                      children: [
                        if (widget.word.synonyms != "" &&
                            widget.word.synonyms != null)
                          TextButton(
                              child: Text(
                                "==",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  show = widget.word.synonyms;
                                });
                              }),
                        if (widget.word.antonyms != "" &&
                            widget.word.antonyms != null)
                          IconButton(
                              icon: Icon(
                                Icons.close,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  show = widget.word.antonyms;
                                });
                              }),
                        if (widget.word.eng != "" && widget.word.eng != null)
                          IconButton(
                              icon: Icon(
                                Icons.translate,
                                color: kPrimaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  show = widget.word.eng;
                                });
                              })
                      ],
                    ),
                  ),

                  if (show != "")
                    Container(
                      width: 350.w,
                      height: 38.h,
                      margin: EdgeInsets.only(right: 15.w, left: 15.w),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.grey[200]),
                          borderRadius: BorderRadius.circular(25)),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              show,
                              style: style(
                                  "en", 15.sp, FontWeight.w400, Colors.black),
                            ),
                          )
                        ],
                      ),
                    ),

                  //show conj section
                  if (conj.length > 0)
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Container(
                          decoration: containerdecoration(
                              kPrimaryColor, kPrimaryColor, 20.sp),
                          padding: EdgeInsets.all(5.h),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Conjugation".tr,
                                style: style(
                                    lung, 18.sp, FontWeight.w400, Colors.white),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            width: 380.w,
                            padding: EdgeInsets.only(top: 15.h),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey[200]),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                for (int i = 0; i < conj.length; i++) conj[i]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  //show Collocations section
                  if (Collocations.length > 0)
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Container(
                          decoration: containerdecoration(
                              kPrimaryColor, kPrimaryColor, 20.sp),
                          padding: EdgeInsets.all(5.h),
                          child: Row(
                            children: [
                              Text(
                                "Collocations".tr,
                                style: style(
                                    lung, 18.sp, FontWeight.w400, Colors.white),
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            width: 380.w,
                            padding: EdgeInsets.only(top: 15.h),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(color: Colors.grey[200]),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                for (int i = 0; i < Collocations.length; i++)
                                  Collocations[i]
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  //show usageNotes section
                  if (widget.word.usageNotes != "" &&
                      widget.word.usageNotes != null)
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Container(
                          padding: EdgeInsets.all(5.h),
                          decoration: containerdecoration(
                              kPrimaryColor, kPrimaryColor, 20.sp),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Usage Notes".tr,
                                style: style(
                                    lung, 18.sp, FontWeight.w400, Colors.white),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                            ],
                          ),
                        ),
                        children: [
                          Row(
                            mainAxisAlignment: Get.locale.toString() == 'ar'
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 380.w,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border.all(color: Colors.grey[200]),
                                    borderRadius: BorderRadius.circular(15)),
                                height: 0.22.sh,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                ),
                                child: Text(
                                  widget.word.usageNotes,
                                  textAlign: TextAlign.right,
                                  style: style(
                                      "ar", 17, FontWeight.w300, Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
