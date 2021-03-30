import 'package:flutter/material.dart';
import 'package:joker/constants/config.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/models/membership.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/models/specializations.dart';
import 'package:joker/ui/about_us.dart';
import 'package:joker/ui/address_list.dart';
import 'package:joker/ui/advanced_search.dart';
import 'package:joker/ui/contact_us.dart';
import 'package:joker/ui/widgets/main_drawer.dart';
import 'package:joker/ui/merchant_memberships.dart';
import 'package:joker/ui/auth/registration_screen.dart';
import 'package:joker/ui/membership_details.dart';
import 'package:joker/ui/my_membership.dart';
import 'package:joker/ui/auth/pin_code.dart';
import 'package:joker/ui/auth/pinCode_for_profile.dart';
import 'package:joker/ui/auth/reset_password.dart';
import 'package:joker/ui/auth/change_password.dart';
import 'package:joker/ui/auth/forget_password.dart';
import 'package:joker/ui/auth//profile.dart';
import 'package:joker/ui/notifications_screen.dart';
import 'package:joker/ui/sale_screen_new.dart';
import 'package:joker/ui/setLocation.dart';
import 'package:joker/ui/map_as_home.dart';
import 'package:joker/ui/settings.dart';
import 'package:joker/ui/merchant_details.dart';
import 'package:joker/ui/favorite_screen.dart';
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
          child: const Home(), type: PageTransitionType.rightToLeftWithFade);
      break;
    // case "/HomeMap":
    //   page = PageTransition<PageController>(
    //     child: HOMEMAP(
    //       lat: args['home_map_lat'] as double,
    //       long: args['home_map_long'] as double,
    //     ),
    //     type: PageTransitionType.rightToLeftWithFade,
    //   );
    //   break;
    case "/login":
      page = PageTransition<PageController>(
          child: LoginScreen(), type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/settings":
      page = PageTransition<PageController>(
          child: const Settings(),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    // case "/SaleDetails":
    //   page = PageTransition<PageController>(
    //     child: SaleDetailPage(
    //       //  merchantId: args['merchant_id'] as int,
    //       saleData: args['sale'] as SaleData,
    //     ),
    //     type: PageTransitionType.rightToLeftWithFade,
    //   );
    //   break;
    case "/SaleLoader":
      page = PageTransition<PageController>(
          child: SaleLoader(
            merchant: args['mapBranch'] as MapBranch,
            saleData: args['sale'] as SaleData,
          ),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AutoLocate":
      page = PageTransition<PageController>(
          child: AutoLocate(
              lat: args['lat'] as double,
              long: args['long'] as double,
              choice: args['choice'] as int),
          type: PageTransitionType.rightToLeftWithFade);
      break;
    case "/AdvancedSearch":
      page = PageTransition<PageController>(
        child: AdvancedSearch(
          specializations: args['specializations'] as List<Specialization>,
        ),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MerchantDetails":
      page = PageTransition<PageController>(
        child: ShopDetails(
            merchantId: args['merchantId'] as int,
            branchId: args['branchId'] as int,
            source: args['source'].toString()),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/Membership":
      page = PageTransition<PageController>(
        child: MyMemberShip(/*args['membershipsData'] as List<MemberShip>*/),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MembershipDetails":
      page = PageTransition<PageController>(
        child: MemberShipDetails(
            mermbershipData: args['membership'] as MembershipData),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MemberShipsForMerchant":
      page = PageTransition<PageController>(
        child: MemberShipsForMerchant(merchantId: args["merchantId"] as int),
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
    case "/pinForProfile":
      page = PageTransition<PageController>(
        child: PinCodeForProfile(mobileNo: args['mobileNo'].toString()),
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
    case "/ContactUs":
      page = PageTransition<PageController>(
        child: ContactUs(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/AddressList":
      page = PageTransition<PageController>(
        child: const AddressList(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/AboutUs":
      page = PageTransition<PageController>(
        child: AboutUs(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/WhereToGo":
      page = PageTransition<PageController>(
        child: const LoadWhereToGo(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MapAsHome":
      page = PageTransition<PageController>(
        child: MapAsHome(
          lat: args['home_map_lat'] as double ?? config.lat,
          long: args['home_map_long'] as double ?? config.long,
        ),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
    case "/MainMenu":
      page = PageTransition<PageController>(
        child: const MainMenu(),
        type: PageTransitionType.rightToLeftWithFade,
      );
      break;
  }

  return page;
}
