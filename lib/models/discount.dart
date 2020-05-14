import 'dart:ui';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/material.dart';

class Discount {

  Discount(
      {this.id,
      this.title,
      this.image,
      this.display,
      this.startingDate,
      this.endDtae,
      this.desc});
   int id;
   String title;
   String image;
   Color display;
   String startingDate;
   String endDtae;
   String desc;

 Discount fromJson(Map<String, dynamic> json) {
   return Discount(
    id:id = json['cat_note'] as int,
   title: title = json['cat_todo'] as String,
   image: image = json['cat_rem'] as String,
  display:  display = json['cat_tag'] as Color,
  startingDate:  startingDate = json['cat_urgent'] as String,
  endDtae:  endDtae = json['cat_work'] as String,
   desc: desc = json['cat_office'] as String,
    
   );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['cat_note'] = id;
    data['cat_todo'] = title;
    data['cat_rem'] = image;
    data['cat_tag'] = display;
    data['cat_urgent'] = startingDate;
    data['cat_work'] = endDtae;
    data['cat_office'] = desc;
    
    return data;
  }
  static List<Discount> get movieData =>  <Discount>[


         Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
          endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
           
            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
                 Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
           
            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
                 Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
           
            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
                 Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(

            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
                 Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
           
            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
                 Discount(
          image: "assets/images/discount_.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
          image: "assets/images/discounttwo.png",
          display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
         Discount(
           
            image: "assets/images/discount.png",
            display:Colors.green,
            endDtae:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          startingDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now())
        ),
             ];
}
