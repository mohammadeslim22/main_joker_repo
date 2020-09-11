import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:joker/models/merchant.dart';
import 'package:joker/util/dio.dart';
import 'package:dio/dio.dart';
import 'package:joker/models/branches_model.dart';

class SalesProvider with ChangeNotifier {
    PagewiseLoadController<dynamic> pagewiseSalesController;

}
