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
