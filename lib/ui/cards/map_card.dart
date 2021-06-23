import 'package:flutter/material.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:joker/services/navigationService.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/util/size_config.dart';
import 'package:map_launcher/map_launcher.dart' as map_luncher;
import 'package:joker/constants/styles.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapCard extends StatelessWidget {
  const MapCard({Key key, this.rs, this.value, this.isAuthintecated})
      : super(key: key);
  final SaleData rs;
  final HOMEMAProvider value;
  final bool isAuthintecated;
  dynamic openMapsSheet(BuildContext context, map_luncher.Coords coords) async {
    try {
      const String title = "Ocean Beach";
      final List<map_luncher.AvailableMap> availableMaps =
          await map_luncher.MapLauncher.installedMaps;

      showModalBottomSheet<dynamic>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    for (map_luncher.AvailableMap map in availableMaps)
                      ListTile(
                        onTap: () => map.showMarker(
                          coords: coords,
                          title: title,
                        ),
                        title: Text(map.mapName),
                        leading: SvgPicture.asset(
                          map.icon,
                          height: 30.0,
                          width: 30.0,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    String endsIn = "";

    if (rs.period is! String) {
      final String yearsToEnd = rs.period[0] != 0
          ? rs.period[0].toString() + " " + trans(context, 'year') + ","
          : "";
      final String monthsToEnd = rs.period[1] != 0
          ? rs.period[1].toString() + " " + trans(context, 'month') + ","
          : "";
      final String daysToEnd = rs.period[2] != 0
          ? rs.period[2].toString() + " " + trans(context, 'day') + ","
          : "";
      final String hoursToEnd = rs.period[3] != 0
          ? rs.period[3].toString() + " " + trans(context, 'hour') + ","
          : "";
      final String minutesToEnd = rs.period[4] != 0
          ? rs.period[4].toString() + " " + trans(context, 'minute') + "."
          : "";
      endsIn = "$yearsToEnd $monthsToEnd $daysToEnd $hoursToEnd $minutesToEnd";
    } else {
      endsIn = rs.period.toString();
    }
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), color: colors.white),
        child: Column(
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        imageUrl: rs.mainImage,
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return const Icon(Icons.error);
                        },
                        fit: BoxFit.cover,
                        height: SizeConfig.blockSizeVertical * 8,
                        width: SizeConfig.blockSizeHorizontal * 16,
                      )),
                  const SizedBox(width: 8),
                  Expanded(
                    
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(rs.name, style: styles.saleNameInMapCard),
                        const SizedBox(height: 12),
                        Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(rs.details,
                                style: styles.saledescInMapCard))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.star, color: colors.orange),
                      Text(value.inFocusBranch.merchant.ratesAverage
                          .toString())
                    ],
                  )
                ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment:
                          isRTL ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        color: colors.orange,
                        padding: EdgeInsets.zero,
                        width: SizeConfig.blockSizeHorizontal * 20,
                        height: SizeConfig.blockSizeVertical * 4,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.resolveWith<
                                    EdgeInsetsGeometry>(
                                (Set<MaterialState> states) {
                              return EdgeInsets.zero;
                            }),
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.green;
                                return colors
                                    .orange; // Use the component's default.
                              },
                            ),
                          ),
                          child: Text(trans(context, 'more_info_map_card'),
                              style: styles.moreInfoWhite),
                          onPressed: () {
                            if (isAuthintecated) {
                              Navigator.pushNamed(context, "/SaleLoader",
                                  arguments: <String, dynamic>{
                                    "mapBranch": value.inFocusBranch,
                                    "sale": rs
                                  });
                            } else {
                              getIt<NavigationService>()
                                  .navigateTo('/login', null);
                            }
                          },
                        ),
                      )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset("assets/images/28_discount.png",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 10),
                        Text("  " + trans(context, 'discount') + "  ",
                            style: styles.moreInfo),
                        Text(rs.discount)
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset("assets/images/cash_png.png",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 10),
                        Text("  " + rs.price + " currency",
                            style: styles.moreInfo)
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset("assets/images/sale_time.png",
                            fit: BoxFit.cover,
                            height: SizeConfig.blockSizeVertical * 5,
                            width: SizeConfig.blockSizeHorizontal * 10),
                        Text(
                            "  " +
                                rs.startAt +
                                " " +
                                trans(context, 'to') +
                                " " +
                                rs.endAt +
                                "  ",
                            style: styles.moreInfo),
                        Text(rs.status)
                      ]),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset("assets/images/time_left.png",
                                fit: BoxFit.cover,
                                height: SizeConfig.blockSizeVertical * 5,
                                width: SizeConfig.blockSizeHorizontal * 10),
                            Text("  " + trans(context, 'ends_in') + "  ",
                                style: styles.moreInfo),
                            Container(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width /
                                            2.85),
                                child: Text(
                                  endsIn,
                                  textAlign: TextAlign.start,
                                )),
                          ],
                        ),
                        LikeButton(
                          circleSize: SizeConfig.blockSizeHorizontal * 12,
                          size: SizeConfig.blockSizeHorizontal * 7,
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          countPostion: CountPostion.bottom,
                          circleColor: const CircleColor(
                              start: Colors.blue, end: Colors.purple),
                          isLiked: rs.isfavorite == 1,
                          onTap: (bool loved) async {
                            favFunction("App\\Sale", rs.id);
                            if (!loved) {
                              value.setFavSale(rs.id);
                            } else {
                              value.setunFavSale(rs.id);
                            }
                            return !loved;
                          },
                          likeCountPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ]),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) => colors.orange),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                    (Set<MaterialState> states) => RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colors.orange))),
                padding: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) =>
                        const EdgeInsets.symmetric(horizontal: 24)),
              ),
              onPressed: () async {
                final map_luncher.Coords crods = map_luncher.Coords(
                    value.inFocusBranch.latitude,
                    value.inFocusBranch.longitude);
                openMapsSheet(context, crods);
              },
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("G", style: styles.googlemapsG),
                const Text("  "),
                Text(trans(context, 'maps'), style: styles.maps)
              ]),
            ),
            const SizedBox(height: 8),
          ],
        ));
  }
}
