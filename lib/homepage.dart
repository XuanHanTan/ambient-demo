import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:ambient/setup1.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CircleProgress.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

var ctemp = "0.0";
var oldtemp = 0;
var cprefs = 10;
var maxtemp = 35;
var mintemp = 10;
var preftemp;
List<double> sldatalist = [];
var totalsavings = 0.0;
var timezone = 0;
DateTime timerInf;
var Dynamic = true;
AnimationController progressController;
Animation<double> animation;
AnimationController colorController;
Animation colorTween;
AnimationController colorControllerG1;
Animation colorTweenG1;
var tabindex = 1;
var oldx = 0.0;
var oldy = 0.0;
var isOff = true;
var autoOffEnabled = false;
var isOffMaster = true;
var currentSelection = 0;
StreamSubscription<DocumentSnapshot> statlistener;
var tiplist = [
  {
    "content":
        "Did you know that your air-conditioner can use up to 2250W when running? That equates to over 40 fans running at the same time. Enable \"Dyamically adjust temperature\" and let Ambient reduce your power usage.",
    "action": "enableDynamic"
  },
  {
    "content":
        "Statistics show that the most efficient temperature for running an air-conditioner is 25℃, allowing you to reduce your electrical bill by 10%. Tap the button below to set your air-conditioner temperature to 25℃.",
    "action": "set25"
  },
  {
    "content":
        "Ever felt like your air-conditioner temperature makes you feel too cold? Try setting a minimum temperature warning to prevent you from accidentaly lowering the temperature by too much.",
    "action": "minTempWarning",
  }
];
var selTipIndex = 0;

class HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  dynamicTemp() async {
    Firestore.instance
        .collection("demo")
        .document("prefs")
        .get()
        .then((element) async {
      var preftemp2;
      if (element["isDynamic"] == true && element["offMaster"] != true) {
        Firestore.instance
            .collection("demo")
            .document("temp")
            .get()
            .then((value) async {
          if (double.parse(value["current"]) > preftemp) {
            setState(() {
              preftemp2 = element["prefs"];
            });

            print(preftemp2);
            if (preftemp2 - 1 >= element["min"] ?? 10) {
              var nprefs = preftemp2;
              Firestore.instance
                  .collection("demo")
                  .document(element.documentID)
                  .updateData({"prev": nprefs});
              setState(() {
                nprefs--;
              });
              print(nprefs);
              Firestore.instance
                  .collection("demo")
                  .document(element.documentID)
                  .updateData({"prefs": nprefs});
              Firestore.instance
                  .collection("demo")
                  .document("control")
                  .updateData({
                "adj": true,
              });
              setState(() {
                cprefs = nprefs;
              });
              Firestore.instance
                  .collection("demo")
                  .document("stats")
                  .get()
                  .then((value) {
                DateTime now = DateTime.now().toUtc();
                var tsList = value["ts"] ?? [];
                var tsList2 = [];
                tsList.forEach((element) {
                  tsList2.add(element);
                });
                print(preftemp);
                print("pref");
                tsList2.add({
                  "time":
                      "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                  "adj": true,
                  "diff": (preftemp2 - preftemp)
                });
                Firestore.instance
                    .collection("demo")
                    .document("stats")
                    .updateData({"ts": tsList2});
              });
              if (isOff) {
                setState(() {
                  isOff = false;
                });
                Firestore.instance
                    .collection("demo")
                    .document("prefs")
                    .updateData({
                  "off": isOff,
                });

                Firestore.instance
                    .collection("demo")
                    .document("control")
                    .updateData({
                  "poweron": true,
                  "poweroff": false,
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                colorTweenG1 = ColorTween(
                        begin: colorTweenG1.value,
                        end: isOff
                            ? Colors.grey[400]
                            : cprefs < 20
                                ? Colors.blue[100]
                                : Colors.greenAccent)
                    .animate(colorControllerG1);
                prefs.setBool("isOff", isOff);
                Firestore.instance
                    .collection("demo")
                    .document("stats")
                    .get()
                    .then((value) {
                  DateTime now = DateTime.now().toUtc();
                  var tsList = value["ts"] ?? [];
                  var tsList2 = [];
                  tsList.forEach((element) {
                    tsList2.add(element);
                  });
                  tsList2.add({
                    "time":
                        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                    "off": isOff
                  });
                  Firestore.instance
                      .collection("demo")
                      .document("stats")
                      .updateData({"ts": tsList2});
                });
              }
            }
          } else if (double.parse(value["current"]) < preftemp) {
            setState(() {
              preftemp2 = element["prefs"];
            });

            if (preftemp2 + 1 <= 25 && preftemp2 + 1 <= element["max"] ?? 35) {
              var nprefs = preftemp2;
              Firestore.instance
                  .collection("demo")
                  .document(element.documentID)
                  .updateData({"prev": nprefs});
              setState(() {
                nprefs++;
              });
              Firestore.instance
                  .collection("demo")
                  .document(element.documentID)
                  .updateData({"prefs": nprefs});
              Firestore.instance
                  .collection("demo")
                  .document("control")
                  .updateData({
                "adj": true,
              });
              setState(() {
                cprefs = nprefs;
              });
              Firestore.instance
                  .collection("demo")
                  .document("stats")
                  .get()
                  .then((value) {
                DateTime now = DateTime.now().toUtc();
                var tsList = value["ts"] ?? [];
                var tsList2 = [];
                tsList.forEach((element) {
                  tsList2.add(element);
                });
                print(preftemp);
                print("pref");
                tsList2.add({
                  "time":
                      "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                  "adj": true,
                  "diff": (preftemp2 - preftemp)
                });
                Firestore.instance
                    .collection("demo")
                    .document("stats")
                    .updateData({"ts": tsList2});
              });
              if (isOff) {
                setState(() {
                  isOff = false;
                });
                Firestore.instance
                    .collection("demo")
                    .document("prefs")
                    .updateData({
                  "off": isOff,
                });
                Firestore.instance
                    .collection("demo")
                    .document("control")
                    .updateData({
                  "poweron": true,
                  "poweroff": false,
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                colorTweenG1 = ColorTween(
                        begin: colorTweenG1.value,
                        end: isOff
                            ? Colors.grey[400]
                            : cprefs < 20
                                ? Colors.blue[100]
                                : Colors.greenAccent)
                    .animate(colorControllerG1);
                prefs.setBool("isOff", isOff);
                Firestore.instance
                    .collection("demo")
                    .document("stats")
                    .get()
                    .then((value) {
                  DateTime now = DateTime.now().toUtc();
                  var tsList = value["ts"] ?? [];
                  var tsList2 = [];
                  tsList.forEach((element) {
                    tsList2.add(element);
                  });
                  tsList2.add({
                    "time":
                        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                    "off": isOff
                  });
                  Firestore.instance
                      .collection("demo")
                      .document("stats")
                      .updateData({"ts": tsList2});
                });
              }
            } else {
              Firestore.instance
                  .collection("demo")
                  .document("control")
                  .get()
                  .then((value2) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Firestore.instance
                    .collection("demo")
                    .document("control")
                    .updateData({
                  "poweroff": true,
                  "poweron": false,
                  "adj": false,
                });
                Firestore.instance
                    .collection("demo")
                    .document("prefs")
                    .updateData({
                  "off": true,
                });

                setState(() {
                  isOff = true;
                });
                prefs.setBool("isOff", true);
                Firestore.instance
                    .collection("demo")
                    .document("stats")
                    .get()
                    .then((value) {
                  DateTime now = DateTime.now().toUtc();
                  var tsList = value["ts"] ?? [];
                  var tsList2 = [];
                  tsList.forEach((element) {
                    tsList2.add(element);
                  });
                  tsList2.add({
                    "time":
                        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                    "off": isOff
                  });
                  Firestore.instance
                      .collection("demo")
                      .document("stats")
                      .updateData({"ts": tsList2});
                });
              });
            }
          }
        });
      } else {
        if (isOff && isOffMaster != true) {
          setState(() {
            isOff = false;
          });
          Firestore.instance.collection("demo").document("prefs").updateData({
            "off": isOff,
          });
          Firestore.instance.collection("demo").document("control").updateData({
            "poweron": true,
            "poweroff": false,
            "adj": false,
          });

          SharedPreferences prefs = await SharedPreferences.getInstance();
          colorTweenG1 = ColorTween(
                  begin: colorTweenG1.value,
                  end: isOff
                      ? Colors.grey[400]
                      : cprefs < 20 ? Colors.blue[100] : Colors.greenAccent)
              .animate(colorControllerG1);
          prefs.setBool("isOff", isOff);
          Firestore.instance
              .collection("demo")
              .document("stats")
              .get()
              .then((value) {
            DateTime now = DateTime.now().toUtc();
            var tsList = value["ts"] ?? [];
            var tsList2 = [];
            tsList.forEach((element) {
              tsList2.add(element);
            });
            tsList2.add({
              "time":
                  "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}",
              "off": isOff
            });
            Firestore.instance
                .collection("demo")
                .document("stats")
                .updateData({"ts": tsList2});
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  statlistener2(sel) {
    var hours = 0;
    if (sel == 0) {
      setState(() {
        hours = 24;
      });
    } else if (sel == 1) {
      setState(() {
        hours = 168;
      });
    } else if (sel == 2) {
      setState(() {
        hours = 8760;
      });
    }
    statlistener = Firestore.instance
        .collection("demo")
        .document("stats")
        .snapshots()
        .listen((event) {
      DateTime now = DateTime.now();
      List<List<Map>> sections = [];
      setState(() {
        sldatalist = [];
        totalsavings = 0;
      });
      if (event["ts"] != null) {
        for (var i = 0; i <= hours - 1; i++) {
          setState(() {
            sldatalist.add(0.0);
            sections.add([]);
          });
        }
        event["ts"].forEach((element) {
          DateFormat time = DateFormat("yyyy-MM-dd hh:mm:ss");
          DateTime tstime = time.parse(element["time"]);
          if (now.difference(tstime.add(Duration(hours: timezone))).inHours <=
              hours) {
            setState(() {
              sections[tstime
                      .difference(now
                          .subtract(Duration(hours: timezone))
                          .subtract(Duration(hours: hours)))
                      .inHours
                      .round()]
                  .add(element);
            });
          }
        });

        DateTime prevSSection;
        var prevSPower = 0.0;
        var prevAdjPower = 0.0;
        sections.asMap().forEach((key, element) {
          element.forEach((element2) {
            DateFormat time = DateFormat("yyyy-MM-dd hh:mm:ss");
            DateTime tstime =
                time.parse(element2["time"]).add(Duration(hours: timezone));
            if (prevSSection != null) {
              if (((tstime.difference(prevSSection).inSeconds / 3600) *
                      prevSPower) >
                  750.0) {
                print("more than 750Wh");
                var rempower =
                    ((tstime.difference(prevSSection).inSeconds / 3600) *
                        prevSPower);
                print("rem $rempower key = $key");
                for (var i = key; (i >= 0 && rempower > 0); i--) {
                  var curr = sldatalist[i];
                  setState(() {
                    sldatalist[i] = 750.0;
                  });
                  setState(() {
                    rempower -= 750.0 - curr;
                  });
                  print("rem $rempower key = $key");
                  if (rempower.isNegative) {
                    setState(() {
                      sldatalist[i] = 750.0 - rempower.abs();
                    });
                  }
                  print(sldatalist);
                }
              } else {
                setState(() {
                  sldatalist[key] = sldatalist[key] +
                      (tstime.difference(prevSSection).inSeconds / 3600) *
                          prevSPower;
                });
              }
              print(prevSPower);
              print((tstime.difference(prevSSection).inSeconds / 3600) *
                  prevSPower);
              print(prevSSection);
            }
            if (element2["off"] == true) {
              setState(() {
                prevSPower = 750.0;
              });
            } else {
              if (element2["adj"] == true) {
                setState(() {
                  prevSPower = (element2["diff"] * 137.5);
                  prevAdjPower = (element2["diff"] * 137.5);
                });
              } else {
                setState(() {
                  prevSPower = 0.0;
                });
              }
            }
            setState(() {
              prevSSection = DateTime(tstime.year, tstime.month, tstime.day,
                  tstime.hour, tstime.minute, tstime.second);
            });
          });
        });
        print(sldatalist);
        sldatalist.forEach((element) {
          setState(() {
            totalsavings += element;
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    var rng = Random();
    setState(() {
      selTipIndex = rng.nextInt(3);
    });
    colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    colorTween = ColorTween(begin: Colors.blue[300], end: Colors.blue[300])
        .animate(colorController);
    colorControllerG1 = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    colorTweenG1 = ColorTween(begin: Colors.blue[100], end: Colors.blue[100])
        .animate(colorControllerG1);

    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    animation = Tween<double>(begin: 0.0, end: 0.0).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
    Firestore.instance.collection("demo").document("prefs").get().then((value) {
      setState(() {
        Dynamic = value["isDynamic"] ?? false;
        maxtemp = value["max"] ?? 35;
        mintemp = value["min"] ?? 10;
        cprefs = value["prefs"] ?? 10;
        isOff = value["off"] ?? true;
      });
    });

    statlistener2(currentSelection);
    Firestore.instance
        .collection("demo")
        .document("prefs")
        .snapshots()
        .listen((value) {
      setState(() {
        maxtemp = value["max"] ?? 35;
        mintemp = value["min"] ?? 10;
      });
      progressController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000));
      animation = Tween<double>(
              begin: animation.value,
              end: ((cprefs - bottom) / (top - bottom)) * 100)
          .animate(progressController)
            ..addListener(() {
              setState(() {});
            });
      colorControllerG1 = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000));
      progressController.forward();
      if (cprefs > oldtemp && cprefs >= 28 && oldtemp <= 28) {
        colorTweenG1 =
            ColorTween(begin: Colors.greenAccent, end: Colors.red[300])
                .animate(colorControllerG1);
      } else if (cprefs < oldtemp && cprefs < 28 && oldtemp >= 28) {
        print("$cprefs $oldtemp");

        colorTweenG1 =
            ColorTween(begin: Colors.red[300], end: Colors.greenAccent)
                .animate(colorControllerG1);
      } else if (cprefs < oldtemp && cprefs < 20 && oldtemp >= 20) {
        print("1");

        colorTweenG1 =
            ColorTween(begin: Colors.greenAccent, end: Colors.blue[100])
                .animate(colorControllerG1);
      } else if (cprefs < oldtemp && cprefs < 20 && oldtemp < 20) {
        print("1");

        colorTweenG1 =
            ColorTween(begin: Colors.blue[100], end: Colors.blue[100])
                .animate(colorControllerG1);
      } else if (cprefs > oldtemp && cprefs < 20) {
        colorTweenG1 =
            ColorTween(begin: Colors.blue[100], end: Colors.blue[100])
                .animate(colorControllerG1);
      } else if (cprefs > oldtemp && oldtemp < 20) {
        colorTweenG1 =
            ColorTween(begin: Colors.blue[100], end: Colors.greenAccent)
                .animate(colorControllerG1);
        print('hot');
      }

      colorControllerG1.forward();

      print(oldtemp);
      print(cprefs);

      setState(() {
        oldtemp = value["prefs"];
      });
    });
    Firestore.instance
        .collection("demo")
        .document("temp")
        .snapshots()
        .listen((event) {
      setState(() {
        ctemp = event["current"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 750;
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      home: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: [
              Opacity(
                  opacity: 0.75,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          colorTweenG1.value,
                          Colors.blueAccent[400],
                        ])),
                  )),
              Column(
                children: [
                  Container(height: 30),
                  Expanded(
                    child: Swiper(
                      viewportFraction: 0.9,
                      scale: 0.9,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return temperature();
                        } else if (index == 1) {
                          return preferences(context);
                        } else if (index == 2) {
                          return statistics();
                        }
                      },
                      itemCount: 3,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  Widget temperature() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 750;
    return Stack(
      children: [
        Opacity(
            opacity: 0.7,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 650 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: WidgetsBinding.instance.window.platformBrightness ==
                          Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                ),
              ),
            )),
        Align(
          child: Container(
              height: 650 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "TEMPERATURE",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 20),
                  Container(
                    height: 300,
                    child: CustomPaint(
                        foregroundPainter: CircleProgress(animation
                            .value), // this will add custom painter after child
                        child: Center(
                            child: Text(
                          "$cprefs°C",
                          style: TextStyle(
                            fontSize: 60,
                          ),
                        ))),
                  ),
                  Container(height: 20),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        thumbColor: isOff
                            ? Colors.grey
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[200]
                                    : Colors.green[200]
                                : Colors.red[200],
                        activeTrackColor: isOff
                            ? Colors.grey[600]
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[300]
                                    : Colors.green[300]
                                : Colors.redAccent,
                        activeTickMarkColor: isOff
                            ? Colors.grey[600]
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[300]
                                    : Colors.green[300]
                                : Colors.redAccent,
                        inactiveTickMarkColor: Colors.white,
                        inactiveTrackColor: Colors.white),
                    child: Slider(
                      value: ((((cprefs ?? bottom) - bottom) / (top - bottom)) *
                          100),
                      onChangeStart: (ncprefs) {
                        var temporaryTemp =
                            (((ncprefs / 100) * (top - bottom)) + bottom)
                                .toInt();
                        Firestore.instance
                            .collection("demo")
                            .document("prefs")
                            .updateData({"prev": temporaryTemp});
                      },
                      onChangeEnd: (ncprefs) async {
                        var temporaryTemp =
                            (((ncprefs / 100) * (top - bottom)) + bottom)
                                .toInt();

                        if (temporaryTemp <= top) {
                          print("$temporaryTemp temp");

                          Firestore.instance
                              .collection("demo")
                              .document("prefs")
                              .updateData({"prefs": temporaryTemp});
                          Firestore.instance
                              .collection("demo")
                              .document("control")
                              .updateData({
                            "adj": true,
                          });
                          if (isOff) {
                            setState(() {
                              isOff = false;
                              isOffMaster = false;
                            });
                            Firestore.instance
                                .collection("demo")
                                .document("prefs")
                                .updateData(
                                    {"off": isOff, "offMaster": isOffMaster});
                            Firestore.instance
                                .collection("demo")
                                .document("control")
                                .updateData({
                              "poweron": true,
                              "poweroff": false,
                            });

                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            colorTweenG1 = ColorTween(
                                    begin: colorTweenG1.value,
                                    end: isOff
                                        ? Colors.grey[400]
                                        : cprefs < 20
                                            ? Colors.blue[100]
                                            : Colors.greenAccent)
                                .animate(colorControllerG1);
                            prefs.setBool("isOff", isOff);
                            prefs.setBool("isOffMaster", isOffMaster);
                            Firestore.instance
                                .collection("demo")
                                .document("stats")
                                .get()
                                .then((value) {
                              DateTime now = DateTime.now().toUtc();
                              var tsList = value["ts"] ?? [];
                              var tsList2 = [];
                              tsList.forEach((element) {
                                tsList2.add(element);
                              });
                              tsList2.add({
                                "time":
                                    "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                                "off": isOff
                              });
                              Firestore.instance
                                  .collection("demo")
                                  .document("stats")
                                  .updateData({"ts": tsList2});
                            });
                          }
                        }
                      },
                      onChanged: (ncprefs) {
                        var temporaryTemp =
                            (((ncprefs / 100) * (top - bottom)) + bottom)
                                .toInt();
                        if (temporaryTemp == (maxtemp + 1) &&
                            temporaryTemp > oldtemp) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  title: Text("Maximum temperature reached"),
                                  content: Container(
                                    height: 170,
                                    child: Column(
                                      children: [
                                        Text(
                                            "Maximum temperature warning is set to $maxtemp°C. Do you wish to continue?"),
                                        Container(height: 25),
                                        ButtonBar(
                                          children: [
                                            FlatButton(
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Continue",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  cprefs = temporaryTemp;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else if (temporaryTemp == (mintemp - 1) &&
                            temporaryTemp < oldtemp) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  title: Text("Minimum temperature reached"),
                                  content: Container(
                                    height: 170,
                                    child: Column(
                                      children: [
                                        Text(
                                            "Minimum temperature warning is set to $mintemp°C. Do you wish to continue?"),
                                        Container(height: 25),
                                        ButtonBar(
                                          children: [
                                            FlatButton(
                                              child: Text(
                                                "Close",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Continue",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  cprefs = temporaryTemp;
                                                });
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          setState(() {
                            cprefs = temporaryTemp;
                          });
                        }
                      },
                      label: "$cprefs°C",
                      divisions: (top - bottom),
                      min: 0,
                      max: 100,
                    ),
                  ),
                  InkResponse(
                    child: SwitchListTile(
                        activeColor: isOff
                            ? Colors.grey
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[200]
                                    : Colors.green[200]
                                : Colors.red[200],
                        inactiveThumbColor: isOff
                            ? Colors.grey
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[200]
                                    : Colors.green[200]
                                : Colors.red[200],
                        activeTrackColor: isOff
                            ? Colors.grey[600]
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[300]
                                    : Colors.green[300]
                                : Colors.redAccent,
                        inactiveTrackColor: Colors.white,
                        title: Text(
                          "Dynamically adjust temperature",
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          "Preferred temperature: ${preftemp == null ? cprefs : preftemp}°C",
                          style: TextStyle(fontSize: 12),
                        ),
                        value: Dynamic,
                        onChanged: (selection) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            Dynamic = !Dynamic;
                            preftemp = cprefs;
                          });
                          if (selection == true) {
                            prefs.setBool("isDynamic", Dynamic);
                            prefs.setInt("preftemp", preftemp);
                          }
                          Firestore.instance
                              .collection("demo")
                              .document("prefs")
                              .updateData(
                                  {"isDynamic": Dynamic, "preferred": cprefs});
                          dynamicTemp();
                        }),
                    onLongPress: () {
                      var preftemp1 = preftemp;
                      var temporaryTemp;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setStateS) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                title: Text("Adjust preferred temperature"),
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Container(height: 25),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            thumbColor: preftemp1 < 28
                                                ? preftemp1 < 20
                                                    ? Colors.blue[200]
                                                    : Colors.green[200]
                                                : Colors.red[200],
                                            activeTrackColor: preftemp1 < 28
                                                ? preftemp1 < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                            activeTickMarkColor: preftemp1 < 28
                                                ? preftemp1 < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                            inactiveTickMarkColor:
                                                Colors.grey[200],
                                            inactiveTrackColor:
                                                Colors.grey[200]),
                                        child: Slider(
                                          value: ((((preftemp1) - bottom) /
                                                  (top - bottom)) *
                                              100),
                                          onChanged: (npreftemp1) {
                                            temporaryTemp =
                                                (((npreftemp1 / 100) *
                                                            (top - bottom)) +
                                                        bottom)
                                                    .toInt();

                                            setStateS(() {
                                              preftemp1 = temporaryTemp;
                                            });
                                          },
                                          label: "$preftemp1°C",
                                          divisions: (top - bottom),
                                          min: 0,
                                          max: 100,
                                        ),
                                      ),
                                      Container(height: 10),
                                      ButtonBar(
                                        children: [
                                          FlatButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Set",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            onPressed: () async {
                                              if (preftemp1 <= 35) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("prefs")
                                                    .updateData({
                                                  "preferred": preftemp1
                                                });
                                                setState(() {
                                                  preftemp = temporaryTemp;
                                                });
                                                prefs.setInt(
                                                    "preftemp", preftemp);
                                                dynamicTemp();
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                          });
                    },
                  ),
                  InkResponse(
                      onLongPress: () async {
                        await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(3000, 1, 1, 00, 00))
                            .then((value2) async {
                          if (value2 == null) {
                          } else {
                            await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) async {
                              if (value == null) {
                                setState(() {
                                  timerInf = DateTime(
                                      value2.year,
                                      value2.month,
                                      value2.day,
                                      timerInf.hour,
                                      timerInf.minute);
                                });
                              } else {
                                setState(() {
                                  timerInf = DateTime(value2.year, value2.month,
                                      value2.day, value.hour, value.minute);
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool("autoOff", true);
                                prefs.setInt("offHour", value.hour);
                                prefs.setInt("offMinute", value.minute);
                                prefs.setInt("offYear", value2.year);
                                prefs.setInt("offMonth", value2.month);
                                prefs.setInt("offDay", value2.day);
                                BackgroundFetch.scheduleTask(TaskConfig(
                                    taskId: "com.grpg108.ambient.timer",
                                    delay: timerInf
                                        .difference(DateTime.now())
                                        .inMilliseconds // <-- milliseconds
                                    ));
                              }
                            });
                          }
                        });
                      },
                      child: SwitchListTile(
                        activeColor: isOff
                            ? Colors.grey
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[200]
                                    : Colors.green[200]
                                : Colors.red[200],
                        inactiveThumbColor: isOff
                            ? Colors.grey
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[200]
                                    : Colors.green[200]
                                : Colors.red[200],
                        activeTrackColor: isOff
                            ? Colors.grey[600]
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[300]
                                    : Colors.green[300]
                                : Colors.redAccent,
                        inactiveTrackColor: Colors.white,
                        onChanged: (selection) async {
                          setState(() {
                            autoOffEnabled = !autoOffEnabled;
                          });
                          if (autoOffEnabled) {
                            await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3000, 1, 1, 00, 00))
                                .then((value2) async {
                              if (value2 == null) {
                                setState(() {
                                  autoOffEnabled = false;
                                  timerInf = null;
                                });
                              } else {
                                await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) async {
                                  if (value == null) {
                                    setState(() {
                                      autoOffEnabled = false;
                                      timerInf = null;
                                    });
                                  } else {
                                    setState(() {
                                      timerInf = DateTime(
                                          value2.year,
                                          value2.month,
                                          value2.day,
                                          value.hour,
                                          value.minute);
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool("autoOff", true);
                                    prefs.setInt("offHour", value.hour);
                                    prefs.setInt("offMinute", value.minute);
                                    prefs.setInt("offYear", value2.year);
                                    prefs.setInt("offMonth", value2.month);
                                    prefs.setInt("offDay", value2.day);
                                    BackgroundFetch.scheduleTask(TaskConfig(
                                        taskId: "com.grpg108.ambient.timer",
                                        delay: timerInf
                                            .difference(DateTime.now())
                                            .inMilliseconds // <-- milliseconds
                                        ));
                                  }
                                });
                              }
                            });
                          } else {
                            setState(() {
                              timerInf = null;
                              autoOffEnabled = false;
                            });
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("autoOff", false);
                            prefs.setInt("offHour", null);
                            prefs.setInt("offMinute", null);
                            prefs.setInt("offYear", null);
                            prefs.setInt("offMonth", null);
                            prefs.setInt("offDay", null);
                          }
                        },
                        value: autoOffEnabled,
                        title: Text(
                          "Turn off at set time",
                          style: TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          timerInf == null
                              ? "Air conditioner will not turn off"
                              : "Will turn off automatically at ${timerInf.hour.toString().padLeft(2, "0")}:${timerInf.minute.toString().padLeft(2, "0")} ${timerInf.day}/${timerInf.month}/${timerInf.year}",
                          style: TextStyle(fontSize: 12),
                        ),
                      )),
                  IconButton(
                    color: isOff
                        ? Colors.grey[600]
                        : cprefs < 28
                            ? cprefs < 20 ? Colors.blue[300] : Colors.green[300]
                            : Colors.redAccent,
                    icon: Icon(Icons.power_settings_new, size: 50),
                    onPressed: () {
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .get()
                          .then((value2) async {
                        setState(() {
                          isOff = !isOff;
                          isOffMaster = !isOffMaster;
                        });
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        if (isOff) {
                          Firestore.instance
                              .collection("demo")
                              .document("control")
                              .updateData({
                            "poweroff": true,
                            "poweron": false,
                            "adj": false,
                          });
                        } else {
                          Firestore.instance
                              .collection("demo")
                              .document("control")
                              .updateData({
                            "poweron": true,
                            "poweroff": false,
                          });
                        }
                        Firestore.instance
                            .collection("demo")
                            .document("prefs")
                            .updateData(
                                {"offMaster": isOffMaster, "off": isOff});

                        colorTweenG1 = ColorTween(
                                begin: colorTweenG1.value,
                                end: isOff
                                    ? Colors.grey[400]
                                    : cprefs < 20
                                        ? Colors.blue[100]
                                        : Colors.greenAccent)
                            .animate(colorControllerG1);
                        prefs.setBool("isOffMaster", isOffMaster);
                        prefs.setBool("isOff", isOff);
                        if (Dynamic) {
                          Firestore.instance
                              .collection("demo")
                              .document("stats")
                              .get()
                              .then((value) {
                            DateTime now = DateTime.now().toUtc();
                            var tsList = value["ts"] ?? [];
                            var tsList2 = [];
                            tsList.forEach((element) {
                              tsList2.add(element);
                            });
                            tsList2.add({
                              "time":
                                  "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                              "off": isOff
                            });
                            Firestore.instance
                                .collection("demo")
                                .document("stats")
                                .updateData({"ts": tsList2});
                          });
                        }
                      });
                    },
                  )
                ],
              )),
          alignment: Alignment.center,
        ),
      ],
    );
  }

  Widget preferences(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 750;
    return Stack(
      children: [
        Opacity(
            opacity: 0.7,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 650 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: WidgetsBinding.instance.window.platformBrightness ==
                          Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                ),
              ),
            )),
        Align(
          child: Container(
              height: 650 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "PREFERENCES",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 20),
                  Image.asset(
                    "assets/ambient.png",
                    fit: BoxFit.fitWidth,
                  ),
                  ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setStateS) {
                                var maxtemp1 = maxtemp;
                                var temporaryTemp;
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  title: Text("Maximum temperature warning"),
                                  content: Container(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Container(height: 25),
                                        SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                  thumbColor: maxtemp1 < 28
                                                      ? maxtemp1 < 20
                                                          ? Colors.blue[200]
                                                          : Colors.green[200]
                                                      : Colors.red[200],
                                                  activeTrackColor: maxtemp1 <
                                                          28
                                                      ? maxtemp1 < 20
                                                          ? Colors.blue[300]
                                                          : Colors.green[300]
                                                      : Colors.redAccent,
                                                  activeTickMarkColor:
                                                      maxtemp1 < 28
                                                          ? maxtemp1 < 20
                                                              ? Colors.blue[300]
                                                              : Colors
                                                                  .green[300]
                                                          : Colors.redAccent,
                                                  inactiveTickMarkColor:
                                                      Colors.grey[200],
                                                  inactiveTrackColor:
                                                      Colors.grey[200]),
                                          child: Slider(
                                            value: ((((maxtemp1) - mintemp) /
                                                    (top - bottom)) *
                                                100),
                                            onChanged: (nmaxtemp1) {
                                              temporaryTemp =
                                                  (((nmaxtemp1 / 100) *
                                                              (top - bottom)) +
                                                          bottom)
                                                      .toInt();
                                              setState(() {
                                                maxtemp = temporaryTemp;
                                              });
                                              setStateS(() {
                                                maxtemp1 = temporaryTemp;
                                              });
                                            },
                                            label: "$maxtemp1°C",
                                            divisions: (top - bottom),
                                            min: 0,
                                            max: 100,
                                          ),
                                        ),
                                        Container(height: 10),
                                        ButtonBar(
                                          children: [
                                            FlatButton(
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(
                                                "Set",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              onPressed: () {
                                                if (maxtemp1 <= top) {
                                                  Firestore.instance
                                                      .collection("demo")
                                                      .document("prefs")
                                                      .updateData(
                                                          {"max": maxtemp1});
                                                  dynamicTemp();
                                                }
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      leading: Icon(Icons.add, size: 30),
                      title: Text(
                        "Maximum temperature warning",
                      ),
                      subtitle: Text(
                        "Set to $maxtemp°C",
                      )),
                  ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setStateS) {
                              var mintemp1 = mintemp;
                              var temporaryTemp;
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                title: Text("Minimum temperature warning"),
                                content: Container(
                                  height: 150,
                                  child: Column(
                                    children: [
                                      Container(height: 25),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            thumbColor: mintemp1 < 28
                                                ? mintemp1 < 20
                                                    ? Colors.blue[200]
                                                    : Colors.green[200]
                                                : Colors.red[200],
                                            activeTrackColor: mintemp1 < 28
                                                ? mintemp1 < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                            activeTickMarkColor: mintemp1 < 28
                                                ? mintemp1 < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                            inactiveTickMarkColor:
                                                Colors.grey[200],
                                            inactiveTrackColor:
                                                Colors.grey[200]),
                                        child: Slider(
                                          value: ((mintemp1 - bottom) == 0 &&
                                                  (maxtemp - bottom) == 0)
                                              ? 0
                                              : (((mintemp1 - bottom) /
                                                      (maxtemp - bottom)) *
                                                  100),
                                          onChanged: (nmintemp1) {
                                            temporaryTemp = ((((nmintemp1) /
                                                            100) *
                                                        (maxtemp - bottom)) +
                                                    bottom)
                                                .toInt();
                                            setState(() {
                                              mintemp = temporaryTemp;
                                            });
                                            setStateS(() {
                                              mintemp1 = temporaryTemp;
                                            });
                                          },
                                          label: "$mintemp1°C",
                                          divisions: (maxtemp - bottom) == 0
                                              ? 1
                                              : (maxtemp - bottom),
                                          min: 0,
                                          max: 100,
                                        ),
                                      ),
                                      Container(height: 10),
                                      ButtonBar(
                                        children: [
                                          FlatButton(
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Set",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            onPressed: () {
                                              if (mintemp1 < maxtemp) {
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("prefs")
                                                    .updateData(
                                                        {"min": mintemp1});
                                                dynamicTemp();
                                              }
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                          });
                    },
                    leading: Icon(Icons.remove, size: 30),
                    title: Text(
                      "Minimum temperature warning",
                    ),
                    subtitle: Text(
                      "Set to $mintemp°C",
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.developer_board, size: 30),
                    title: Text(
                      "Room temperature",
                    ),
                    subtitle: Text(
                      "${double.parse(ctemp).toInt()}°C",
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings_remote, size: 30),
                    title: Text(
                      "Configure air conditioner settings",
                    ),
                    onTap: () {
                      setState(() {
                        comingFromFinishSU = true;
                      });
                      setState(() {
                        confPowerComplete = false;
                      });
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .updateData({
                        "confPowerOn": true,
                        "signalReceived": false,
                      });

                      streamSub = Firestore.instance
                          .collection("demo")
                          .document("control")
                          .snapshots()
                          .listen((event) {
                        if (event["signalReceived"] == true) {
                          print("true detect");
                          setState(() {
                            confPowerComplete = event["signalReceived"];
                          });
                          streamSub.cancel();
                        }

                        Firestore.instance
                            .collection("demo")
                            .document("control")
                            .updateData({
                          "signalReceived": false,
                        });
                      });

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Setup1()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.ac_unit, size: 30),
                    title: Text(
                      "About Ambient",
                    ),
                    subtitle: Text(
                      "Updated to 1.0-RDE",
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, size: 30),
                    title: Text(
                      "Sign out",
                    ),
                    onTap: () async {
                      setState(() {
                        ctemp = "0.0";
                        oldtemp = 0;
                        cprefs = 10;
                        maxtemp = 35;
                        mintemp = 10;
                        preftemp;
                        Dynamic = true;
                        top = 35;
                        bottom = 10;
                        tabindex = 1;
                        oldx = 0.0;
                        oldy = 0.0;
                        isOff = true;
                        autoOffEnabled = false;
                        timerInf = null;
                        isOffMaster = true;
                        ChkLogIn = false;
                        sr1 = "";
                        comingFromFinishSU = false;
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("isDynamic", false);
                      prefs.setInt("preftemp", 0);
                      prefs.setBool("login", false);
                      prefs.setBool("isOff", true);
                      prefs.setBool("isOffMaster", true);
                      prefs.setInt("top", 35);
                      prefs.setInt("bottom", 10);
                      prefs.setBool("autoOff", false);
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .get()
                          .then((value2) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        Firestore.instance
                            .collection("demo")
                            .document("control")
                            .updateData({
                          "poweroff": true,
                          "poweron": false,
                          "adj": false,
                        });
                        Firestore.instance
                            .collection("demo")
                            .document("prefs")
                            .updateData(
                                {"offMaster": isOffMaster, "off": isOff});

                        colorTweenG1 = ColorTween(
                                begin: colorTweenG1.value,
                                end: isOff
                                    ? Colors.grey[400]
                                    : cprefs < 20
                                        ? Colors.blue[100]
                                        : Colors.greenAccent)
                            .animate(colorControllerG1);
                        prefs.setBool("isOffMaster", isOffMaster);
                        prefs.setBool("isOff", isOff);
                        Firestore.instance
                            .collection("demo")
                            .document("stats")
                            .get()
                            .then((value) {
                          DateTime now = DateTime.now().toUtc();
                          var tsList = value["ts"] ?? [];
                          var tsList2 = [];
                          tsList.forEach((element) {
                            tsList2.add(element);
                          });
                          tsList2.add({
                            "time":
                                "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                            "off": isOff
                          });
                          Firestore.instance
                              .collection("demo")
                              .document("stats")
                              .updateData({"ts": tsList2});
                        });
                      });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Setup1()),
                          (route) => false);
                    },
                  ),
                ],
              )),
          alignment: Alignment.center,
        )
      ],
    );
  }

  Widget statistics() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 750;
    return Stack(
      children: [
        Opacity(
            opacity: 0.7,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 650 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: WidgetsBinding.instance.window.platformBrightness ==
                          Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white,
                ),
              ),
            )),
        Align(
          child: Container(
              height: 650 * scale,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "ENERGY SAVINGS",
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(height: 20),
                  MaterialSegmentedControl(
                    children: {
                      0: Text("24 hours"),
                      1: Text("1 week"),
                      2: Text("1 year"),
                    },
                    selectionIndex: currentSelection,
                    borderColor: Colors.grey,
                    selectedColor: isOff
                        ? Colors.grey[600]
                        : cprefs < 28
                            ? cprefs < 20 ? Colors.blue[300] : Colors.green[300]
                            : Colors.redAccent,
                    unselectedColor: Colors.white,
                    borderRadius: 32.0,
                    onSegmentChosen: (index) {
                      setState(() {
                        currentSelection = index;
                      });
                      statlistener.cancel();
                      statlistener2(currentSelection);
                    },
                  ),
                  Container(height: 20),
                  Sparkline(
                    data: sldatalist.isEmpty ? [0] : sldatalist,
                    lineColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                  Container(height: 20),
                  Center(
                      child: Text("${totalsavings.round() / 1000}kWh",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w200))),
                  Center(
                      child: Text(
                          "saved in the last " +
                              (currentSelection == 0
                                  ? "24 hours"
                                  : currentSelection == 1
                                      ? "1 week"
                                      : "1 year"),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w200))),
                  Container(height: 40),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        height: 220,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("TIP OF THE DAY",
                                style: TextStyle(
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold)),
                            Container(height: 10),
                            Text("${tiplist[selTipIndex]["content"]}"),
                            Container(height: 10),
                            tiplist[selTipIndex]["action"] == "enableDynamic"
                                ? InkResponse(
                                    child: SwitchListTile(
                                        activeColor: isOff
                                            ? Colors.grey
                                            : cprefs < 28
                                                ? cprefs < 20
                                                    ? Colors.blue[200]
                                                    : Colors.green[200]
                                                : Colors.red[200],
                                        inactiveThumbColor: isOff
                                            ? Colors.grey
                                            : cprefs < 28
                                                ? cprefs < 20
                                                    ? Colors.blue[200]
                                                    : Colors.green[200]
                                                : Colors.red[200],
                                        activeTrackColor: isOff
                                            ? Colors.grey[600]
                                            : cprefs < 28
                                                ? cprefs < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                        inactiveTrackColor: Colors.white,
                                        title: Text(
                                          "Dynamically adjust temperature",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          "Preferred temperature: ${preftemp == null ? cprefs : preftemp}°C",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        value: Dynamic,
                                        onChanged: (selection) async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          setState(() {
                                            Dynamic = !Dynamic;
                                            preftemp = cprefs;
                                          });
                                          if (selection == true) {
                                            prefs.setBool("isDynamic", Dynamic);
                                            prefs.setInt("preftemp", preftemp);
                                          }
                                          Firestore.instance
                                              .collection("demo")
                                              .document("prefs")
                                              .updateData({
                                            "isDynamic": Dynamic,
                                            "preferred": cprefs
                                          });
                                          dynamicTemp();
                                        }),
                                    onLongPress: () {
                                      var preftemp1 = preftemp;
                                      var temporaryTemp;
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return StatefulBuilder(
                                                builder: (context, setStateS) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25)),
                                                title: Text(
                                                    "Adjust preferred temperature"),
                                                content: Container(
                                                  height: 150,
                                                  child: Column(
                                                    children: [
                                                      Container(height: 25),
                                                      SliderTheme(
                                                        data: SliderTheme.of(context).copyWith(
                                                            thumbColor: preftemp1 < 28
                                                                ? preftemp1 < 20
                                                                    ? Colors.blue[
                                                                        200]
                                                                    : Colors.green[
                                                                        200]
                                                                : Colors
                                                                    .red[200],
                                                            activeTrackColor: preftemp1 < 28
                                                                ? preftemp1 < 20
                                                                    ? Colors.blue[
                                                                        300]
                                                                    : Colors.green[
                                                                        300]
                                                                : Colors
                                                                    .redAccent,
                                                            activeTickMarkColor: preftemp1 < 20
                                                                ? Colors
                                                                    .blue[300]
                                                                : Colors
                                                                    .green[300],
                                                            inactiveTickMarkColor:
                                                                Colors.grey[200],
                                                            inactiveTrackColor: Colors.grey[200]),
                                                        child: Slider(
                                                          value: ((((preftemp1) -
                                                                      bottom) /
                                                                  (top -
                                                                      bottom)) *
                                                              100),
                                                          onChanged:
                                                              (npreftemp1) {
                                                            temporaryTemp =
                                                                (((npreftemp1 / 100) *
                                                                            (top -
                                                                                bottom)) +
                                                                        bottom)
                                                                    .toInt();

                                                            setStateS(() {
                                                              preftemp1 =
                                                                  temporaryTemp;
                                                            });
                                                          },
                                                          label: "$preftemp1°C",
                                                          divisions:
                                                              (top - bottom),
                                                          min: 0,
                                                          max: 100,
                                                        ),
                                                      ),
                                                      Container(height: 10),
                                                      ButtonBar(
                                                        children: [
                                                          FlatButton(
                                                            child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          FlatButton(
                                                            child: Text(
                                                              "Set",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (preftemp1 <=
                                                                  35) {
                                                                SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                Firestore
                                                                    .instance
                                                                    .collection(
                                                                        "demo")
                                                                    .document(
                                                                        "prefs")
                                                                    .updateData({
                                                                  "preferred":
                                                                      preftemp1
                                                                });
                                                                setState(() {
                                                                  preftemp =
                                                                      temporaryTemp;
                                                                });
                                                                prefs.setInt(
                                                                    "preftemp",
                                                                    preftemp);
                                                                dynamicTemp();
                                                              }
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                          });
                                    },
                                  )
                                : tiplist[selTipIndex]["action"] == "set25"
                                    ? RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        color: isOff
                                            ? Colors.grey[600]
                                            : cprefs < 28
                                                ? cprefs < 20
                                                    ? Colors.blue[300]
                                                    : Colors.green[300]
                                                : Colors.redAccent,
                                        onPressed: () async {
                                          if (top >= 25) {
                                            if (maxtemp <= 25 &&
                                                cprefs <= maxtemp) {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                      title: Text(
                                                          "Maximum temperature reached"),
                                                      content: Container(
                                                        height: 130,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                "Maximum temperature warning is set to $maxtemp°C. Do you wish to continue?"),
                                                            Container(
                                                                height: 25),
                                                            ButtonBar(
                                                              children: [
                                                                FlatButton(
                                                                  child: Text(
                                                                    "Close",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: Text(
                                                                    "Continue",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "demo")
                                                                        .document(
                                                                            "prefs")
                                                                        .updateData({
                                                                      "prev":
                                                                          cprefs
                                                                    });
                                                                    setState(
                                                                        () {
                                                                      cprefs =
                                                                          25;
                                                                    });
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "demo")
                                                                        .document(
                                                                            "prefs")
                                                                        .updateData({
                                                                      "prefs":
                                                                          25
                                                                    });
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "demo")
                                                                        .document(
                                                                            "control")
                                                                        .updateData({
                                                                      "adj":
                                                                          true,
                                                                    });
                                                                    if (isOff) {
                                                                      setState(
                                                                          () {
                                                                        isOff =
                                                                            false;
                                                                        isOffMaster =
                                                                            false;
                                                                      });
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "demo")
                                                                          .document(
                                                                              "prefs")
                                                                          .updateData({
                                                                        "off":
                                                                            isOff,
                                                                        "offMaster":
                                                                            isOffMaster
                                                                      });
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "demo")
                                                                          .document(
                                                                              "control")
                                                                          .updateData({
                                                                        "poweron":
                                                                            true,
                                                                        "poweroff":
                                                                            false,
                                                                      });

                                                                      SharedPreferences
                                                                          prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      colorTweenG1 = ColorTween(
                                                                              begin: colorTweenG1.value,
                                                                              end: isOff ? Colors.grey[400] : cprefs < 20 ? Colors.blue[100] : Colors.greenAccent)
                                                                          .animate(colorControllerG1);
                                                                      prefs.setBool(
                                                                          "isOff",
                                                                          isOff);
                                                                      prefs.setBool(
                                                                          "isOffMaster",
                                                                          isOffMaster);
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "demo")
                                                                          .document(
                                                                              "stats")
                                                                          .get()
                                                                          .then(
                                                                              (value) {
                                                                        DateTime
                                                                            now =
                                                                            DateTime.now().toUtc();
                                                                        var tsList =
                                                                            value["ts"] ??
                                                                                [];
                                                                        var tsList2 =
                                                                            [];
                                                                        tsList.forEach(
                                                                            (element) {
                                                                          tsList2
                                                                              .add(element);
                                                                        });
                                                                        tsList2
                                                                            .add({
                                                                          "time":
                                                                              "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                                                                          "off":
                                                                              isOff
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                "demo")
                                                                            .document(
                                                                                "stats")
                                                                            .updateData({
                                                                          "ts":
                                                                              tsList2
                                                                        });
                                                                      });
                                                                    }
                                                                    if (Dynamic) {
                                                                      SharedPreferences
                                                                          prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();
                                                                      Firestore
                                                                          .instance
                                                                          .collection(
                                                                              "demo")
                                                                          .document(
                                                                              "prefs")
                                                                          .updateData({
                                                                        "preferred":
                                                                            25
                                                                      });
                                                                      setState(
                                                                          () {
                                                                        preftemp =
                                                                            25;
                                                                      });
                                                                      prefs.setInt(
                                                                          "preftemp",
                                                                          25);
                                                                      dynamicTemp();
                                                                    }
                                                                    _scaffoldKey
                                                                        .currentState
                                                                        .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Your air-conditioner temperature has been set successfully to 25°C")));
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            } else {
                                              Firestore.instance
                                                  .collection("demo")
                                                  .document("prefs")
                                                  .updateData({"prev": cprefs});
                                              setState(() {
                                                cprefs = 25;
                                              });
                                              Firestore.instance
                                                  .collection("demo")
                                                  .document("prefs")
                                                  .updateData({"prefs": 25});
                                              Firestore.instance
                                                  .collection("demo")
                                                  .document("control")
                                                  .updateData({
                                                "adj": true,
                                              });
                                              if (isOff) {
                                                setState(() {
                                                  isOff = false;
                                                  isOffMaster = false;
                                                });
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("prefs")
                                                    .updateData({
                                                  "off": isOff,
                                                  "offMaster": isOffMaster
                                                });
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("control")
                                                    .updateData({
                                                  "poweron": true,
                                                  "poweroff": false,
                                                });

                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                colorTweenG1 = ColorTween(
                                                        begin:
                                                            colorTweenG1.value,
                                                        end: isOff
                                                            ? Colors.grey[400]
                                                            : cprefs < 20
                                                                ? Colors
                                                                    .blue[100]
                                                                : Colors
                                                                    .greenAccent)
                                                    .animate(colorControllerG1);
                                                prefs.setBool("isOff", isOff);
                                                prefs.setBool(
                                                    "isOffMaster", isOffMaster);
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("stats")
                                                    .get()
                                                    .then((value) {
                                                  DateTime now =
                                                      DateTime.now().toUtc();
                                                  var tsList =
                                                      value["ts"] ?? [];
                                                  var tsList2 = [];
                                                  tsList.forEach((element) {
                                                    tsList2.add(element);
                                                  });
                                                  tsList2.add({
                                                    "time":
                                                        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")} ${now.hour.toString().padLeft(2, "0")}:${now.minute.toString().padLeft(2, "0")}:${now.second.toString().padLeft(2, "0")}",
                                                    "off": isOff
                                                  });
                                                  Firestore.instance
                                                      .collection("demo")
                                                      .document("stats")
                                                      .updateData(
                                                          {"ts": tsList2});
                                                });
                                              }
                                              if (Dynamic) {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                Firestore.instance
                                                    .collection("demo")
                                                    .document("prefs")
                                                    .updateData(
                                                        {"preferred": 25});
                                                setState(() {
                                                  preftemp = 25;
                                                });
                                                prefs.setInt("preftemp", 25);
                                                dynamicTemp();
                                              }
                                              _scaffoldKey.currentState
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Your air-conditioner temperature has been set successfully to 25°C")));
                                            }
                                          } else {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error: Your air-conditioner does not support setting the temperature to 25°C")));
                                          }
                                        },
                                        child: Text("Set temperature to 25℃"))
                                    : ListTile(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context, setStateS) {
                                                  var mintemp1 = mintemp;
                                                  var temporaryTemp;
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                    title: Text(
                                                        "Minimum temperature warning"),
                                                    content: Container(
                                                      height: 150,
                                                      child: Column(
                                                        children: [
                                                          Container(height: 25),
                                                          SliderTheme(
                                                            data: SliderTheme.of(context).copyWith(
                                                                thumbColor: mintemp1 < 20
                                                                    ? Colors.blue[
                                                                        200]
                                                                    : Colors.green[
                                                                        200],
                                                                activeTrackColor: mintemp1 < 20
                                                                    ? Colors.blue[
                                                                        300]
                                                                    : Colors.green[
                                                                        300],
                                                                activeTickMarkColor: mintemp1 < 20
                                                                    ? Colors.blue[
                                                                        300]
                                                                    : Colors.green[
                                                                        300],
                                                                inactiveTickMarkColor:
                                                                    Colors.grey[
                                                                        200],
                                                                inactiveTrackColor:
                                                                    Colors.grey[200]),
                                                            child: Slider(
                                                              value: ((mintemp1 -
                                                                              bottom) ==
                                                                          0 &&
                                                                      (maxtemp -
                                                                              bottom) ==
                                                                          0)
                                                                  ? 0
                                                                  : (((mintemp1 -
                                                                              bottom) /
                                                                          (maxtemp -
                                                                              bottom)) *
                                                                      100),
                                                              onChanged:
                                                                  (nmintemp1) {
                                                                temporaryTemp =
                                                                    ((((nmintemp1) / 100) *
                                                                                (maxtemp - bottom)) +
                                                                            bottom)
                                                                        .toInt();
                                                                setState(() {
                                                                  mintemp =
                                                                      temporaryTemp;
                                                                });
                                                                setStateS(() {
                                                                  mintemp1 =
                                                                      temporaryTemp;
                                                                });
                                                              },
                                                              label:
                                                                  "$mintemp1°C",
                                                              divisions: (maxtemp -
                                                                          bottom) ==
                                                                      0
                                                                  ? 1
                                                                  : (maxtemp -
                                                                      bottom),
                                                              min: 0,
                                                              max: 100,
                                                            ),
                                                          ),
                                                          Container(height: 10),
                                                          ButtonBar(
                                                            children: [
                                                              FlatButton(
                                                                child: Text(
                                                                  "Cancel",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              FlatButton(
                                                                child: Text(
                                                                  "Set",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                onPressed: () {
                                                                  if (mintemp1 <
                                                                      maxtemp) {
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            "demo")
                                                                        .document(
                                                                            "prefs")
                                                                        .updateData({
                                                                      "min":
                                                                          mintemp1
                                                                    });
                                                                    dynamicTemp();
                                                                  }
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                        },
                                        leading: Icon(Icons.remove, size: 30),
                                        title: Text(
                                          "Minimum temperature warning",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        subtitle: Text(
                                          "Set to $mintemp°C",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                          ],
                        ),
                      )),
                ],
              )),
          alignment: Alignment.center,
        )
      ],
    );
  }
}
