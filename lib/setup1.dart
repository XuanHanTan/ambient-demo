import 'dart:async';

import './homepage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setup1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Setup1State();
  }
}

var ChkLogIn = false;
var sr1;
var confPowerComplete = false;
var top = 35;
var bottom = 10;
var comingFromFinishSU = false;
BuildContext context2;
TextEditingController controller3;
// StreamSubscription<DocumentSnapshot> streamSub;
PageController controller;

class Setup1State extends State<Setup1> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      controller = PageController(initialPage: comingFromFinishSU ? 2 : 0);
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context1) {
    context2 = context1;
    // TODO: implement build
    return MaterialApp(
        darkTheme: ThemeData.dark(),
        home: Scaffold(
            body: Stack(children: [
          Opacity(
              opacity: 0.75,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                      Colors.grey[400],
                      Colors.blueAccent[400],
                    ])),
              )),
          Column(
            children: [
              Container(height: 30),
              Expanded(
                  child: PageView(
                      controller: controller,
                      physics: new NeverScrollableScrollPhysics(),
                      children: [
                    setup1(),
                    setup2(),
                    setup3(),
                    setup3_2(),
                    setup4(),
                    setup5(),
                    setup6(),
                    setup7(context1)
                  ]))
            ],
          )
        ])));
  }

  Widget setup1() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;

    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "WELCOME",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Type in your serial number to continue",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      TextFormField(
                        controller: controller3,
                        onChanged: (serial) {
                          setState(() {
                            sr1 = serial;
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Serial number",
                        ),
                        initialValue: "1234",
                      )
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      FocusScope.of(context2).unfocus();
                      controller.animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Next",
                      style: TextStyle(color: Colors.green[300]),
                    ),
                    icon: Icon(Icons.arrow_forward, color: Colors.green[300]),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
              alignment: Alignment.bottomRight,
            )
          ],
        ));
  }

  Widget setup2() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CONFIGURE AMBIENT REMOTE",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Get your air-conditioner remote ready",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      Icon(Icons.settings_remote,
                          color: Colors.green[300], size: 200 * scale)
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      /*Firestore.instance
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
                      });*/

                      // DEMO: Hardware-interfacing code has been replaced with simulation code
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          confPowerComplete = true;
                        });
                      });

                      controller.animateToPage(2,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Start",
                      style: TextStyle(color: Colors.green[300]),
                    ),
                    icon: Icon(Icons.arrow_forward, color: Colors.green[300]),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
              alignment: Alignment.bottomRight,
            ),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      setState(() {
                        sr1 = "";
                      });
                      controller.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Back",
                      style: TextStyle(
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }

  Widget setup3() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CONFIGURE POWER ON",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Point your air conditioner remote at the Ambient Remote and press the power button",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      Icon(Icons.power_settings_new,
                          color: Colors.green[300], size: 200 * scale),
                      Container(height: 40),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: confPowerComplete
                              ? Column(
                                  children: [
                                    Icon(Icons.done,
                                        color: Colors.green[300], size: 35),
                                    Container(height: 10),
                                    Text("Configuration success")
                                  ],
                                )
                              : Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(height: 10),
                                    Text("Waiting for signal")
                                  ],
                                ))
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            confPowerComplete
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              confPowerComplete = false;
                            });

                            /*Firestore.instance
                                .collection("demo")
                                .document("control")
                                .updateData({
                              "confPowerOff": true,
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
                            });*/

                            // DEMO: Hardware-interfacing code has been replaced with simulation code
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                confPowerComplete = true;
                              });
                            });

                            controller.animateToPage(3,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Next",
                            style: TextStyle(color: Colors.green[300]),
                          ),
                          icon: Icon(Icons.arrow_forward,
                              color: Colors.green[300]),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
            !comingFromFinishSU
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              confPowerComplete = false;
                              sr1 = "";
                            });

                            // streamSub.cancel();

                            controller.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Back",
                            style: TextStyle(
                              color: WidgetsBinding
                                          .instance.window.platformBrightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            color: WidgetsBinding
                                        .instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
                    alignment: Alignment.bottomLeft,
                  )
                : Container()
          ],
        ));
  }

  Widget setup3_2() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CONFIGURE POWER OFF",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Point your air conditioner remote at the Ambient Remote and press the power button",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      Icon(Icons.power_settings_new,
                          color: Colors.grey[600], size: 200 * scale),
                      Container(height: 40),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: confPowerComplete
                              ? Column(
                                  children: [
                                    Icon(Icons.done,
                                        color: Colors.green[300], size: 35),
                                    Container(height: 10),
                                    Text("Configuration success")
                                  ],
                                )
                              : Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(height: 10),
                                    Text("Waiting for signal")
                                  ],
                                ))
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            confPowerComplete
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              confPowerComplete = false;
                            });

                            /*Firestore.instance
                                .collection("demo")
                                .document("control")
                                .updateData({
                              "confInc": true,
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
                            });*/

                            // DEMO: Hardware-interfacing code has been replaced with simulation code
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                confPowerComplete = true;
                              });
                            });

                            controller.animateToPage(4,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Next",
                            style: TextStyle(color: Colors.green[300]),
                          ),
                          icon: Icon(Icons.arrow_forward,
                              color: Colors.green[300]),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      setState(() {
                        confPowerComplete = true;
                        sr1 = "";
                      });

                      /*streamSub.cancel();
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .updateData({
                        "confPowerOn": true,
                        "confPowerOff": false,
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
                      });*/

                      controller.animateToPage(2,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Back",
                      style: TextStyle(
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }

  Widget setup4() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CONFIGURE TEMPERATURE INCREASE",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Point your air conditioner remote at the Ambient Remote and press the temperature increase button",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      Icon(Icons.keyboard_arrow_up,
                          color: Colors.green[300], size: 200 * scale),
                      Container(height: 40),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: confPowerComplete
                              ? Column(
                                  children: [
                                    Icon(Icons.done,
                                        color: Colors.green[300], size: 35),
                                    Container(height: 10),
                                    Text("Configuration success")
                                  ],
                                )
                              : Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(height: 10),
                                    Text("Waiting for signal")
                                  ],
                                ))
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            confPowerComplete
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              confPowerComplete = false;
                            });

                            /*Firestore.instance
                                .collection("demo")
                                .document("control")
                                .updateData({
                              "confDec": true,
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
                            });*/

                            // DEMO: Hardware-interfacing code has been replaced with simulation code
                            Future.delayed(Duration(seconds: 2), () {
                              setState(() {
                                confPowerComplete = true;
                              });
                            });

                            controller.animateToPage(5,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Next",
                            style: TextStyle(color: Colors.green[300]),
                          ),
                          icon: Icon(Icons.arrow_forward,
                              color: Colors.green[300]),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                      elevation: 0.0,
                      backgroundColor:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                      onPressed: () {
                        setState(() {
                          confPowerComplete = true;
                          sr1 = "";
                        });

                        /*streamSub.cancel();
                        setState(() {
                          confPowerComplete = false;
                        });
                        Firestore.instance
                            .collection("demo")
                            .document("control")
                            .updateData({
                          "confPowerOff": true,
                          "confInc": false,
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
                        });*/

                        controller.animateToPage(3,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      label: Text(
                        "Back",
                        style: TextStyle(
                          color: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_back,
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      )),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }

  Widget setup5() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CONFIGURE TEMPERATURE DECREASE",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Point your air conditioner remote at the Ambient Remote and press the temperature decrease button",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.red[400], size: 200 * scale),
                      Container(height: 40),
                      AnimatedSwitcher(
                          duration: Duration(milliseconds: 100),
                          child: confPowerComplete
                              ? Column(
                                  children: [
                                    Icon(Icons.done,
                                        color: Colors.green[300], size: 35),
                                    Container(height: 10),
                                    Text("Configuration success")
                                  ],
                                )
                              : Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    Container(height: 10),
                                    Text("Waiting for signal")
                                  ],
                                ))
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            confPowerComplete
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            setState(() {
                              confPowerComplete = false;
                              isOff = true;
                            });

                            //streamSub.cancel();

                            controller.animateToPage(6,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Next",
                            style: TextStyle(color: Colors.green[300]),
                          ),
                          icon: Icon(Icons.arrow_forward,
                              color: Colors.green[300]),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      setState(() {
                        confPowerComplete = true;
                        sr1 = "";
                      });

                      /*streamSub.cancel();
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .updateData({
                        "confInc": true,
                        "confDec": false,
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
                      });*/

                      controller.animateToPage(4,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Back",
                      style: TextStyle(
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }

  Widget setup6() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "POWER ON AIR CONDITIONER",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Tap the on-screen power button to turn on your air conditioner",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 100),
                      IconButton(
                        iconSize: 200 * scale,
                        color: isOff
                            ? Colors.grey[600]
                            : cprefs < 28
                                ? cprefs < 20
                                    ? Colors.blue[300]
                                    : Colors.green[300]
                                : Colors.redAccent,
                        icon: Icon(Icons.power_settings_new, size: 200 * scale),
                        onPressed: () {
                          /*Firestore.instance
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
                              });
                            } else {
                              Firestore.instance
                                  .collection("demo")
                                  .document("control")
                                  .updateData({
                                "poweron": true,
                              });
                            }
                            Firestore.instance
                                .collection("demo")
                                .document("prefs")
                                .updateData(
                                    {"offMaster": isOffMaster, "off": isOff});

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
                          });*/

                          // DEMO: Hardware-interfacing code has been replaced with simulation code
                          setState(() {
                            isOff = !isOff;
                            isOffMaster = !isOffMaster;
                          });
                        },
                      ),
                      Container(height: 40),
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            !isOff
                ? Align(
                    child: Padding(
                        child: FloatingActionButton.extended(
                          elevation: 0.0,
                          backgroundColor: WidgetsBinding
                                      .instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                          onPressed: () {
                            controller.animateToPage(7,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.ease);
                          },
                          label: Text(
                            "Next",
                            style: TextStyle(color: Colors.green[300]),
                          ),
                          icon: Icon(Icons.arrow_forward,
                              color: Colors.green[300]),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
                    alignment: Alignment.bottomRight,
                  )
                : Container(),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      setState(() {
                        confPowerComplete = true;
                        sr1 = "";
                      });

                      /*streamSub.cancel();
                      Firestore.instance
                          .collection("demo")
                          .document("control")
                          .updateData({
                        "confDec": true,
                        "poweroff": false,
                        "poweron": false,
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
                      });*/

                      controller.animateToPage(5,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Back",
                      style: TextStyle(
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }

  double tempincF = 1.0;
  Widget setup7(context1) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var scale = height / 850;
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 30),
        child: Stack(
          children: [
            Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 700 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.grey[800]
                              : Colors.white,
                    ),
                  ),
                )),
            Align(
              child: Container(
                  height: 700 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: EdgeInsets.all(15),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "CURRENT INFORMATION",
                        style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 20),
                      Text(
                        "Enter additional information about your air conditioner here",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 40),
                      ListTile(
                        title: Text("Temperature increase factor"),
                        subtitle: Text("$tempincF℃"),
                        onTap: () {
                          double ntempincF;
                          setState(() {
                            ntempincF = tempincF;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setStateS) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    title:
                                        Text("Set temperature increase factor"),
                                    content: Container(
                                      height: 210,
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                              value: 0.5,
                                              title: Text("0.5℃"),
                                              groupValue: ntempincF,
                                              onChanged: (selection) {
                                                setStateS(() {
                                                  ntempincF = selection;
                                                });
                                                print(ntempincF);
                                              }),
                                          RadioListTile(
                                              value: 1.0,
                                              title: Text("1℃"),
                                              groupValue: ntempincF,
                                              onChanged: (selection) {
                                                setStateS(() {
                                                  ntempincF = selection;
                                                });
                                              }),
                                          Container(height: 25),
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    tempincF = ntempincF;
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
                              });
                        },
                      ),
                      ListTile(
                        title: Text("Maximum possible temperature"),
                        subtitle: Text("$top℃"),
                        onTap: () {
                          var maxtemp1;
                          setState(() {
                            maxtemp1 = top;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setStateS) {
                                  var temporaryTemp;
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    title: Text(
                                        "Set maximum possible temperature"),
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
                                                                ? Colors
                                                                    .blue[300]
                                                                : Colors
                                                                    .green[300]
                                                            : Colors.redAccent,
                                                    inactiveTickMarkColor:
                                                        Colors.grey[200],
                                                    inactiveTrackColor:
                                                        Colors.grey[200]),
                                            child: Slider(
                                              value: ((((maxtemp1) - bottom) /
                                                      25) *
                                                  100),
                                              onChanged: (nmaxtemp1) {
                                                temporaryTemp =
                                                    (((nmaxtemp1 / 100) * 25) +
                                                            bottom)
                                                        .toInt();

                                                setStateS(() {
                                                  maxtemp1 = temporaryTemp;
                                                });
                                              },
                                              label: "$maxtemp1°C",
                                              divisions: 25,
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                onPressed: () async {
                                                  // DEMO: Hardware-interfacing code has been replaced with simulation code
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  if (cprefs > top) {
                                                    cprefs = top;
                                                  }
                                                  top = maxtemp1;

                                                  setState(() {});

                                                  Navigator.pop(context);

                                                  await prefs.setInt(
                                                      "cprefs", cprefs);
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
                      ListTile(
                        title: Text("Minimum possible temperature"),
                        subtitle: Text("$bottom℃"),
                        onTap: () {
                          var mintemp1;
                          setState(() {
                            mintemp1 = bottom;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setStateS) {
                                  var temporaryTemp;
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    title: Text(
                                        "Set minimum possible temperature"),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          Container(height: 25),
                                          SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                                    thumbColor: mintemp1 < 28
                                                        ? mintemp1 < 20
                                                            ? Colors.blue[200]
                                                            : Colors.green[200]
                                                        : Colors.red[200],
                                                    activeTrackColor: mintemp1 <
                                                            28
                                                        ? mintemp1 < 20
                                                            ? Colors.blue[300]
                                                            : Colors.green[300]
                                                        : Colors.redAccent,
                                                    activeTickMarkColor:
                                                        mintemp1 < 28
                                                            ? mintemp1 < 20
                                                                ? Colors
                                                                    .blue[300]
                                                                : Colors
                                                                    .green[300]
                                                            : Colors.redAccent,
                                                    inactiveTickMarkColor:
                                                        Colors.grey[200],
                                                    inactiveTrackColor:
                                                        Colors.grey[200]),
                                            child: Slider(
                                              value: ((mintemp1 - 10) == 0 &&
                                                      (top - 10) == 0)
                                                  ? 0
                                                  : (((mintemp1 - 10) /
                                                          (top - 10)) *
                                                      100),
                                              onChanged: (nmintemp1) {
                                                temporaryTemp =
                                                    ((((nmintemp1) / 100) *
                                                                (top - 10)) +
                                                            10)
                                                        .toInt();

                                                setStateS(() {
                                                  mintemp1 = temporaryTemp;
                                                });
                                              },
                                              label: "$mintemp1°C",
                                              divisions: (top - 10) == 0
                                                  ? 1
                                                  : (top - 10),
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                onPressed: () async {
                                                  // DEMO: Hardware-interfacing code has been replaced with simulation code
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  if (cprefs < mintemp1) {
                                                    cprefs = mintemp1;
                                                  }
                                                  bottom = mintemp1;

                                                  setState(() {});

                                                  Navigator.pop(context);

                                                  await prefs.setInt(
                                                      "cprefs", cprefs);
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
                      ListTile(
                        title: Text("Current set temperature"),
                        subtitle: Text("$cprefs℃"),
                        onTap: () {
                          var cprefs1;
                          setState(() {
                            cprefs1 = cprefs;
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setStateS) {
                                  var temporaryTemp;
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    title: Text("Current set temperature"),
                                    content: Container(
                                      height: 150,
                                      child: Column(
                                        children: [
                                          Container(height: 25),
                                          SliderTheme(
                                            data: SliderTheme.of(context)
                                                .copyWith(
                                                    thumbColor: cprefs1 < 28
                                                        ? cprefs1 < 20
                                                            ? Colors.blue[200]
                                                            : Colors.green[200]
                                                        : Colors.red[200],
                                                    activeTrackColor: cprefs1 <
                                                            28
                                                        ? cprefs1 < 20
                                                            ? Colors.blue[300]
                                                            : Colors.green[300]
                                                        : Colors.redAccent,
                                                    activeTickMarkColor:
                                                        cprefs1 < 28
                                                            ? cprefs1 < 20
                                                                ? Colors
                                                                    .blue[300]
                                                                : Colors
                                                                    .green[300]
                                                            : Colors.redAccent,
                                                    inactiveTickMarkColor:
                                                        Colors.grey[200],
                                                    inactiveTrackColor:
                                                        Colors.grey[200]),
                                            child: Slider(
                                              value: ((cprefs1 - bottom) == 0 &&
                                                      (top - bottom) == 0)
                                                  ? 0
                                                  : (((cprefs1 - bottom) /
                                                          (top - bottom)) *
                                                      100),
                                              onChanged: (ncprefs1) {
                                                temporaryTemp = ((((ncprefs1) /
                                                                100) *
                                                            (top - bottom)) +
                                                        bottom)
                                                    .toInt();

                                                setStateS(() {
                                                  cprefs1 = temporaryTemp;
                                                });
                                              },
                                              label: "$cprefs1°C",
                                              divisions: (top - bottom) == 0
                                                  ? 1
                                                  : (top - bottom),
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
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                onPressed: () async {
                                                  // DEMO: Hardware-interfacing code has been replaced with simulation code
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();

                                                  setState(() {
                                                    cprefs = cprefs1;
                                                  });

                                                  Navigator.pop(context);
                                                  await prefs.setInt(
                                                      "cprefs", cprefs);
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
                    ],
                  )),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    heroTag: "1",
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () async {
                      /*Firestore.instance
                          .collection("demo")
                          .document("prefs")
                          .updateData({
                        "inF": tempincF,
                        "top": top,
                        "bottom": bottom,
                        "prefs": cprefs,
                        "max": top,
                        "min": bottom
                      });*/

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setInt("top", top);
                      prefs.setInt("bottom", bottom);
                      if (!comingFromFinishSU) {
                        prefs.setBool("login", true);
                      } else {
                        setState(() {
                          comingFromFinishSU = false;
                        });
                      }

                      /*Firestore.instance
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
                      });*/

                      setState(() {
                        ChkLogIn = true;
                      });
                      Navigator.pushAndRemoveUntil(
                          context1,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    },
                    label: Text(
                      "Next",
                      style: TextStyle(color: Colors.green[300]),
                    ),
                    icon: Icon(Icons.arrow_forward, color: Colors.green[300]),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 15)),
              alignment: Alignment.bottomRight,
            ),
            Align(
              child: Padding(
                  child: FloatingActionButton.extended(
                    heroTag: "2",
                    elevation: 0.0,
                    backgroundColor:
                        WidgetsBinding.instance.window.platformBrightness ==
                                Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                    onPressed: () {
                      controller.animateToPage(6,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    label: Text(
                      "Back",
                      style: TextStyle(
                        color:
                            WidgetsBinding.instance.window.platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black54,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_back,
                      color:
                          WidgetsBinding.instance.window.platformBrightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black54,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 15)),
              alignment: Alignment.bottomLeft,
            )
          ],
        ));
  }
}
