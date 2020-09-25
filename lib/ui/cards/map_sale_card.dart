import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joker/constants/colors.dart';
import 'package:joker/constants/styles.dart';
import 'package:like_button/like_button.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/service_locator.dart';
import 'package:joker/providers/map_provider.dart';
import '../../ui/cards/sale_card_no_padding.dart';

class MapSalesCard extends StatefulWidget {
  const MapSalesCard({Key key, this.context, this.sale}) : super(key: key);
  final BuildContext context;
  final SaleData sale;

  @override
  _SalesCardState createState() => _SalesCardState();
}

Color saleStatus;

class _SalesCardState extends State<MapSalesCard> {
  bool isliked = false;
  SaleData saledata;
  String branches;
  @override
  void initState() {
    super.initState();
    saledata = widget.sale;
    if (saledata.status == "active") {
      saleStatus = colors.green;
    } else if (saledata.status == "coming") {
      saleStatus = colors.yellow;
    } else {
      saleStatus = colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: InkWell(
        onTap: () {
          getIt<HOMEMAProvider>().pc.close();
          getIt<HOMEMAProvider>().errorController = getIt<HOMEMAProvider>()
              .scaffoldkey
              .currentState
              .showBottomSheet<dynamic>((BuildContext context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          removeBottom: true,
                          removeLeft: true,
                          removeRight: true,
                          child: SalesCardNoPadding(sale: saledata)),
                    ],
                  ));
        },
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 6),
              height: MediaQuery.of(context).size.width * .25,
              width: MediaQuery.of(context).size.width * .25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      saledata.cropedImage,
                      errorListener: () => print('error'),
                    )),
              ),
              child: saledata.isfavorite != 0
                  ? Stack(children: <Widget>[
                      Positioned(
                        left: 8.0,
                        top: 8.0,
                        child: CircleAvatar(
                          backgroundColor: colors.white,
                          radius: 12,
                          child: SvgPicture.asset('assets/images/loveicon.svg'),
                        ),
                      ),
                    ])
                  : Container(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(saledata.name,
                                style: styles.underHeadblack),
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(saledata.status, style: styles.mylight),
                                  const SizedBox(width: 5),
                                  const CircleAvatar(
                                      backgroundColor: Colors.green, radius: 6)
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],
                          )
                        ]),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset("assets/images/merchants.svg",
                                  color: colors.black),
                              const SizedBox(width: 8),
                              Flexible(
                                  child: Text(saledata.merchant.name,
                                      softWrap: true, style: styles.mystyle)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.sale.price ?? "",
                              style: styles.redstyleForSaleScreen,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.sale.oldPrice,
                              style: const TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Flexible(
                        //   child: Row(
                        //     children: <Widget>[
                        //       Text(trans(context, 'branch'),
                        //           style: styles.mylight),
                        //       const SizedBox(width: 10),
                        //       Container(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 16, vertical: 4),
                        //         decoration: BoxDecoration(
                        //           borderRadius: const BorderRadius.all(
                        //               Radius.circular(12)),
                        //           color: Colors.grey[200],
                        //         ),
                        //         alignment: Alignment.center,
                        //         child:
                        //             Text(saledata.branches.length.toString()),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(saledata.startAt, style: styles.mystyle),
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.arrow_forward, size: 20),
                            ),
                            Text(saledata.endAt, style: styles.mystyle),
                          ],
                        ),
                        LikeButton(
                          circleSize: 50,
                          size: 26,
                          likeBuilder: (bool isLiked) {
                            return Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: !isLiked
                                    ? Colors.black.withOpacity(.5)
                                    : Colors.blue,
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Image.asset("assets/images/like.png",
                                  width: 10, height: 10),
                            );
                          },
                          isLiked: isliked,
                          likeCountPadding:
                              const EdgeInsets.symmetric(vertical: 3),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          countBuilder: (int c, bool b, String count) {
                            return Text(
                              count,
                              style: const TextStyle(color: Colors.black),
                            );
                          },
                          likeCount: saledata.id,
                          countPostion: CountPostion.bottom,
                          circleColor: const CircleColor(
                              start: Colors.white, end: Colors.purple),
                          onTap: (bool loved) async {
                            likeFunction("App\\Sale", saledata.id);
                            //  setState(() {
                            isliked = !isliked;
                            //  });

                            return isliked;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
