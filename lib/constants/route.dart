import 'package:flutter/material.dart';
import 'package:joker/models/membership.dart';
import 'package:joker/models/search_filter_data.dart';
import 'package:joker/ui/advanced_search.dart';
import 'package:joker/ui/sale_screen.dart';
import 'package:joker/ui/auth/registration_screen.dart';
import 'package:joker/ui/membership_details.dart';
import 'package:joker/ui/my_membership.dart';
import 'package:joker/ui/auth/pin_code.dart';
import 'package:joker/ui/auth/reset_password.dart';
import 'package:joker/ui/auth/change_password.dart';
import 'package:joker/ui/auth/forget_password.dart';
import 'package:joker/ui/auth//profile.dart';
import 'package:joker/ui/notifications_screen.dart';
import 'package:joker/ui/setLocation.dart';
import 'package:joker/ui/settings.dart';
import 'package:joker/ui/merchant_details.dart';
import 'package:joker/ui/favorite.dart';
import '../ui/auth/login_screen.dart';
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
        child:  Home(salesDataFilter: args['salesDataFilter'] as bool, filterData: args['FilterData'] as FilterData),
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
          case "/SaleDetails":
      page = PageTransition<PageController>(
        child:  SaleDetailPage(merchantId: args['merchant_id'] as int,),
        type: PageTransitionType.rightToLeftWithFade,

      );
      break;
    case "/AutoLocate":
      page = PageTransition<PageController>(
        child: AutoLocate(
          lat: args['lat'] as double,
          long: args['long'] as double,
        ),
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
        child: ShopDetails(
            merchantId: args['merchantId'] as int,
            likecount: args['likecount'] as int,
            lovecount: args['lovecount'] as int),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Membership":
      page = PageTransition<PageController>(
        child: MyMemberShip(args['membershipsData'] as List<MemberShip>),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MembershipDetails":
      page = PageTransition<PageController>(
        child: MemberShipDetails(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Fav":
      page = PageTransition<PageController>(
        child: Favorite(),
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
    case "/Profile":
      page = PageTransition<PageController>(
        child: MyAccount(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/forget_pass":
      page = PageTransition<PageController>(
        child: ForgetPassword(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Reset_pass":
      page = PageTransition<PageController>(
        child: ResetPassword(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
         case "/ChangePassword":
      page = PageTransition<PageController>(
        child: ChangePassword(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
          case "/Notifications":
      page = PageTransition<PageController>(
        child: const Notifcations(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
  }
  return page;
}
