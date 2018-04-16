import 'dart:math';

import 'package:flutter/material.dart';


class IndexOffsetCurve extends Curve {


  IndexOffsetCurve(this.index, {this.delay = 1.0});

  final int index;
  final double delay;

  @override
  double transform(double t) {
    return pow(t, (index + 1) * 2 );
  }

}