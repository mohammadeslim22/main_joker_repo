import 'package:flutter/material.dart';
import 'package:joker/models/membership.dart';
import 'package:joker/models/shop.dart';
import 'package:joker/ui/advanced_search.dart';
import 'package:joker/ui/my_membership.dart';
import 'package:joker/ui/pin_code.dart';
import 'package:joker/ui/setLocation.dart';
import 'package:joker/ui/settings.dart';
import 'package:joker/ui/shop_details.dart';
import 'package:joker/ui/registrationscreen.dart';

import 'package:joker/ui/favorite.dart';
import '../ui/login_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../ui/home.dart';

// Generate all application routes with simple transition
Route<PageController> onGenerateRoute(RouteSettings settings) {
  Route<PageController> page;

  // TODO(ahmed): I will use it for send arguments to custom pages
  final Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

  switch (settings.name) {
    
    case "/Home":
      page = PageTransition<PageController>(
        child: const Home(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/login":
      page = PageTransition<PageController>(
        child: LoginScreen(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/settings":
      page = PageTransition<PageController>(
        child: const Settings(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/AutoLocate":
      page = PageTransition<PageController>(
        child:  AutoLocate(lat: args['lat']as double,long: args['long']as double,),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/AdvancedSearch":
      page = PageTransition<PageController>(
        child: const AdvancedSearch(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/MerchantDetails":
      page = PageTransition<PageController>(
        child:  ShopDetails(shop:args['shop']as Shop,likecount: args['likecount'] as int,lovecount: args['lovecount'] as int,),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/Membership":
      page = PageTransition<PageController>(
        child:  MyMemberShip(args['membershipsData']as List<MemberShip>),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/Fav":
      page = PageTransition<PageController>(
        child:  Favorite(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/pin":
      page = PageTransition<PageController>(
        child: PinCode(mobileNo: args['mobileNo'].toString()),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/Registration":
      page = PageTransition<PageController>(
        child: Registration(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
  }
  return page;
}
