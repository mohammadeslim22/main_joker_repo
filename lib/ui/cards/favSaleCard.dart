import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/sales.dart';
import 'package:joker/providers/salesProvider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/size_config.dart';
import 'package:like_button/like_button.dart';

class FaveCard extends StatelessWidget {
  const FaveCard({Key key, this.sale, this.value}) : super(key: key);
  final SaleData sale;
  final SalesProvider value;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                        width: SizeConfig.blockSizeHorizontal * 14,
                      )),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(sale.name, style: styles.saleNameInMapCard),
                        const SizedBox(height: 12),
                        TextOverflowRapper(mytext: sale.details ),
                      ],
                    ),
                  ),
                ]),
            LikeButton(
              circleSize: SizeConfig.blockSizeHorizontal * 12,
              size: SizeConfig.blockSizeHorizontal * 7,
              padding: const EdgeInsets.symmetric(horizontal: 3),
              countPostion: CountPostion.bottom,
              circleColor:
                  const CircleColor(start: Colors.blue, end: Colors.purple),
              isLiked: sale.isfavorite == 1,
              onTap: (bool loved) async {
                print("loved $loved");
                favFunction("App\\Sale", sale.id);
                if (!loved) {
                  value.setFavSale(sale.id);
                } else {
                  value.setunFavSale(sale.id);
                }
                return !loved;
              },
              likeCountPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ]),
    ));
  }
}

class BottomWidgetForSliver extends StatefulWidget {
  const BottomWidgetForSliver({Key key, this.mytext}) : super(key: key);
  final String mytext;

  @override
  State<StatefulWidget> createState() => BottomWidgetForSliverState();
}

class BottomWidgetForSliverState extends State<BottomWidgetForSliver> {
  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      child:
          LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
        final TextSpan span =
            TextSpan(text: widget.mytext, style: styles.saledescInMapCard);
        final TextPainter tp = TextPainter(
            maxLines: 2, textDirection: TextDirection.ltr, text: span);
        tp.layout(maxWidth: size.maxWidth);
        final bool exceeded = tp.didExceedMaxLines;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text.rich(span,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start),
              InkWell(
                onTap: () {
                  showFullText(context, widget.mytext);
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
