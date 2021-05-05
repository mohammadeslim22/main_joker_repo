import 'package:flutter/material.dart';
import 'package:joker/models/search_filter_data.dart';

class GlobalVars with ChangeNotifier {
  FilterData filterData;
  void setFilterDate(FilterData data) {
    filterData = data;
    notifyListeners();
  }

  void clearilterDate() {
    filterData = FilterData(
        merchantNameOrPartOfit: "",
        saleNameOrPartOfit: "",
        specifications: <int>[1, 2],
        startingdate: DateTime(2020),
        endingdate: DateTime(2900),
        fromPrice: 0,
        toPrice: 99999);
    notifyListeners();
  }
}
