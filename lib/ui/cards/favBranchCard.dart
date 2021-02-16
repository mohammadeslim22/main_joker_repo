import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:joker/localization/trans.dart';
import 'package:joker/models/map_branches.dart';
import 'package:joker/providers/map_provider.dart';
import 'package:joker/util/functions.dart';
import 'package:joker/util/size_config.dart';
import 'package:like_button/like_button.dart';

class FaveBranchCard extends StatelessWidget {
  const FaveBranchCard({Key key, this.branch, this.value})
      : super(key: key);
  final MapBranch branch;
  final HOMEMAProvider value;

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: CachedNetworkImage(
                        imageUrl: branch.merchant.logo,
                        errorWidget:
                            (BuildContext context, String url, dynamic error) {
                          return const Icon(Icons.error);
                        },
                        fit: BoxFit.cover,
                        height: SizeConfig.blockSizeVertical * 8,
                        width: SizeConfig.blockSizeHorizontal * 16,
                      )),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 1.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(branch.name, style: styles.saleNameInMapCard),
                        const SizedBox(height: 12),
                        BottomWidgetForSliver(mytext: branch.address),
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
                  const CircleColor(start: Colors.orange, end: Colors.purple),
              isLiked: branch.isfavorite == 1,
              onTap: (bool loved) async {
                favFunction("App\\Sale", branch.id);
                if (!loved) {
                  value.setFavSale(branch.id);
                } else {
                  value.setunFavSale(branch.id);
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
                  ifUpdateTur(context, widget.mytext);
                },
                child: Visibility(
                    child: Container(
                        alignment: isRTL
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        height: SizeConfig.blockSizeVertical *2,
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