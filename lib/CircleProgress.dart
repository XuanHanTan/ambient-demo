import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ambient/homepage.dart';

class CircleProgress extends CustomPainter{

  double currentProgress;

  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {

    //this is base circle
    Paint outerCircle = Paint()
        ..strokeWidth = 15
        ..color = isOff ? Colors.grey: cprefs < 28 ? cprefs < 20
                                              ? Colors.blue[200]
                                              : Colors.green[200]: Colors.red[200]
        ..style = PaintingStyle.stroke;
if (currentProgress<20.0){
  colorController.reverse();
} else {
  colorController.forward();
}
    Paint completeArc = Paint()
      ..strokeWidth = 15
      ..color = isOff ? Colors.grey[600]:cprefs < 28 ? cprefs < 20
                                              ? Colors.blue[300]
                                              : Colors.green[300]: Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}