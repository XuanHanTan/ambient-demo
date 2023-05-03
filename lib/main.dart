import 'package:ambient/homepage.dart';

import 'package:ambient/setup1.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncinit();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      switch (taskId) {
        case 'com.grpg108.ambient.timer':
          print("Received custom task");
          if (autoOffEnabled) {
            setState(() {
              timerInf = null;
              autoOffEnabled = false;
            });
            Firestore.instance
                .collection("demo")
                .document("control")
                .get()
                .then((value2) async {
              setState(() {
                isOff = true;
                isOffMaster = true;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("autoOff", false);
              prefs.setInt("offHour", null);
              prefs.setInt("offMinute", null);
              prefs.setInt("offYear", null);
              prefs.setInt("offMonth", null);
              prefs.setInt("offDay", null);
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
                    .updateData({"poweron": true, "poweroff": false});
              }
              Firestore.instance
                  .collection("demo")
                  .document("prefs")
                  .updateData({"offMaster": isOffMaster, "off": isOff});

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
          }
          break;
        default:
          print("Default fetch task");
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
                print(value["test"]);
                if (double.parse(value["current"]) > preftemp) {
                  print("current+");

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
                  print("current-");

                  setState(() {
                    preftemp2 = element["prefs"];
                  });

                  print(preftemp2);
                  if (preftemp2 + 1 <= 25 && preftemp2 + 1 <= element["max"] ??
                      35) {
                    var nprefs = preftemp2;
                    Firestore.instance
                        .collection("demo")
                        .document(element.documentID)
                        .updateData({"prev": nprefs});
                    setState(() {
                      nprefs++;
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

        // IMPORTANT:  You must signal completion of your task or the OS can punish your app
        // for taking too long in the background.

      }
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  asyncinit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timezone = DateTime.now().timeZoneOffset.inHours;
    });
    setState(() {
      top = prefs.getInt("top") ?? 35;
      bottom = prefs.getInt("bottom") ?? 10;
    });
    print(top);
    print(bottom);
    setState(() {
      autoOffEnabled = prefs.getBool("autoOff") ?? false;
      if (autoOffEnabled) {
        timerInf = DateTime(
            prefs.getInt("offYear"),
            prefs.getInt("offMonth"),
            prefs.getInt("offDay"),
            prefs.getInt("offHour"),
            prefs.getInt("offMinute"));
      }
      Dynamic = prefs.getBool("isDynamic") ?? false;
      preftemp = prefs.getInt("preftemp") ?? bottom;
      ChkLogIn = prefs.getBool("login") ?? false;
      isOff = prefs.getBool("isOff") ?? false;
      isOffMaster = prefs.getBool("isOffMaster") ?? false;
    });
    print(preftemp);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(home: ChkLogIn ? HomePage() : Setup1());
  }
}
