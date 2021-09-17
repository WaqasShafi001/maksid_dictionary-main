import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:maksid_dictionaty/model/wordsLocalDataBase.dart';
import 'package:maksid_dictionaty/view/view-favorite/favorite.dart';
import '../../const/const.dart';
import 'package:provider/provider.dart';
import '../../functios.dart';
import '../home.dart';
import '../search-screen.dart';
import 'category-viewmodel.dart';

//class WordCategory
class WordCategory extends StatefulWidget {
  @override
  _WordCategoryState createState() => _WordCategoryState();
}

class _WordCategoryState extends State<WordCategory> {
  List<DropdownMenuItem> categories;
  String dropval = "all";
  List<Map> allCategories;
  GetAllcategories() async {
    allCategories = await WordModel_service_database().getallcat();
    List<DropdownMenuItem> item2 = [];
    item2.add(DropdownMenuItem(
      child: GestureDetector(
          child: Center(
        child: Text(
          "all",
          textAlign: TextAlign.center,
          style: style("ar", 17.sp, FontWeight.w400, Colors.black),
        ),
      )),
      value: "all",
      onTap: () {},
    ));
    for (int i = 0; i < allCategories.length; i++) {
      item2.add(DropdownMenuItem(
        child: GestureDetector(
            child: Center(
          child: Text(
            allCategories[i]["cat"],
            textAlign: TextAlign.center,
            style: style("ar", 17.sp, FontWeight.w400, Colors.black),
          ),
        )),
        value: allCategories[i]["cat"],
        onTap: () {
          print(allCategories[i]["cat"]);
        },
      ));
    }
    setState(() {
      categories = item2;
    });
  }

  @override
  void initState() {
    GetAllcategories();
  }

  String lung = Get.locale.toString();
  @override
  Widget build(BuildContext context) {
    var dio = Dio();
    return ChangeNotifierProvider.value(
      value: WordCatProvider(),
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => home()));
        },
        child: Scaffold(
          body: SafeArea(
            child: Selector<WordCatProvider, List>(
              selector: (context, getWord) {
                getWord.fetchCatWordList(dropval);
                return getWord.getWordList;
              },
              builder: (ctx, WordList, widget) {
                return WordList == null
                    ? SpinKitWave(
                        color: kPrimaryColor,
                        size: 50.0,
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/img/bg1-2.jpg"),
                              fit: BoxFit.cover),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Home".tr,
                                            style: style(lung, 17.sp,
                                                FontWeight.w500, Colors.white),
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
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(favoirte());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5.h),
                                      margin: EdgeInsets.all(5.h),
                                      decoration: containerdecoration(
                                          kPrimaryColor, kPrimaryColor, 30.sp),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "fav".tr,
                                            style: style(lung, 17.sp,
                                                FontWeight.w500, Colors.white),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "My Words".tr,
                                              style: style(
                                                  lung,
                                                  17.sp,
                                                  FontWeight.w500,
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
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                              margin: EdgeInsets.all(10.h),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "My Words".tr,
                                    style: style(
                                      lung,
                                      25.sp,
                                      FontWeight.w500,
                                      Colors.black,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.purple),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    width: 240.w,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        items: categories,
                                        hint: Center(
                                            child: Text(
                                          "select category".tr,
                                          style: style(lung, 15,
                                              FontWeight.normal, Colors.black),
                                          textAlign: TextAlign.center,
                                        )),
                                        value: dropval,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 20.r,
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            dropval = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            WordList.length == 0
                                ? Container(
                                    margin: EdgeInsets.all(10.w),
                                    child: Column(
                                      children: [
                                        Text(
                                          "There are no saved my words entries yet. You can add entries by clicking the Add symbol inside the entry screen"
                                              .tr,
                                          style: style(lung, 17.sp,
                                              FontWeight.normal, Colors.black),
                                        ),
                                        Icon(Icons.add_circle_outline)
                                      ],
                                    ),
                                  )
                                : Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          right: 10.h, left: 10.h),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: WordList.length,
                                        itemBuilder: (
                                          context,
                                          index,
                                        ) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SearchScreen(WordList[
                                                              index])));
                                            },
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        WordList[index]
                                                            .entryWithHarakat,
                                                        style: style(
                                                            "ar",
                                                            25.sp,
                                                            FontWeight.w500,
                                                            Colors
                                                                .indigoAccent),
                                                      ),
                                                    ),
                                                    WordList[index].audioFile !=
                                                                null &&
                                                            WordList[index]
                                                                    .audioFile !=
                                                                ""
                                                        ? Expanded(
                                                            child: IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .play_circle_fill,
                                                                  color:
                                                                      kPrimaryColor,
                                                                ),
                                                                onPressed: () {
                                                                  play(WordList[
                                                                          index]
                                                                      .audioFile);
                                                                }),
                                                            flex: 1,
                                                          )
                                                        : Expanded(
                                                            child: SizedBox(
                                                              width: 20.w,
                                                            ),
                                                            flex: 1,
                                                          ),
                                                    if (WordList[index].level !=
                                                        "")
                                                      Expanded(
                                                        child: Text(
                                                          convertlevel(
                                                              WordList[index]
                                                                  .level),
                                                          style: style(
                                                              "ar",
                                                              25.sp,
                                                              FontWeight.w500,
                                                              Colors.black),
                                                        ),
                                                        flex: 1,
                                                      ),
                                                    Expanded(
                                                      child: IconButton(
                                                          icon: Icon(
                                                            Icons.close,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                          onPressed: () {
                                                            WordList[index]
                                                                .cat = "all";
                                                            WordCatProvider()
                                                                .updateWordCat(
                                                                    WordList[
                                                                        index]);
                                                          }),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  color: Colors.black38,
                                                  height: 1,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
