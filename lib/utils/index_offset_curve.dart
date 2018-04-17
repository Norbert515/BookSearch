import 'dart:math';

import 'package:flutter/material.dart';


class IndexOffsetCurve extends Curve {


  IndexOffsetCurve(this.index);

  final int index;

  @override
  double transform(double t) {
    return pow(t, (index + 1) * 2 );
  }

}

class IndexOffsetFractionCurve extends Curve {

  Interval interval;

  IndexOffsetFractionCurve(int index, double delay, double length) {
    var start = delay * index;
    var end = (start + length).clamp(0.0, 1.0);
    interval = new Interval(start, end);
  }

  @override
  double transform(double t) {
    return interval.transform(t);
  }
}