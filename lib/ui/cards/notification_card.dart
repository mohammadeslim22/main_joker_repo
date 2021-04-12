import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/size_config.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({Key key, this.sale, this.value}) : super(key: key);
  final SaleData sale;
  final HOMEMAProvider value;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: const Key("c"),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: sale.mainImage,
                      errorWidget:
                          (BuildContext context, String url, dynamic error) {
                        return const Icon(Icons.error);
                      },
                      fit: BoxFit.cover,
                      height: SizeConfig.blockSizeVertical * 8,
                      width: SizeConfig.blockSizeHorizontal * 16,
                    )),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(sale.name, style: styles.saleNameInMapCard),
                        const Text("time since kickoff")
                      ],
                    ),
                    TextOverflowRapper(
                        mytext: sale.details +
                            "sale.detailssale.details sale.details sale.detailssale.details sale.details")
                  ],
                ),
              ]),
        )));
  }
}

class TextOverflowRapper extends StatelessWidget {
  const TextOverflowRapper({Key key, this.mytext}) : super(key: key);
  final String mytext;

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      child:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
        final TextSpan span =
            TextSpan(text: mytext, style: styles.saledescInMapCard);
        final TextPainter tp = TextPainter(
            maxLines: 3, textDirection: TextDirection.ltr, text: span);
        tp.layout(maxWidth: size.maxWidth);
        final bool exceeded = tp.didExceedMaxLines;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(span,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  textAlign: TextAlign.start),
              InkWell(
                onTap: () {
                  showFullText(context, mytext);
                },
                child: Visibility(
                    child: Container(
                        alignment: isRTL
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        height: SizeConfig.blockSizeVertical * 2,
                        child: Text(trans(context, "show_more"),
                            style: styles.showMore)),
                    visible: exceeded,
                    replacement: Container()),
              )
            ]);
      }),
    );
  }
}
