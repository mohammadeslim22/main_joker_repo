import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joker/constants/styles.dart';
import 'package:rating_bar/rating_bar.dart';
import '../localization/trans.dart';
import 'package:like_button/like_button.dart';

class SaleDetails extends StatefulWidget {
  const SaleDetails({Key key}) : super(key: key);

  @override
  SaleDetailsPage createState() => SaleDetailsPage();
}

class SaleDetailsPage extends State<SaleDetails> with TickerProviderStateMixin {
  Future<bool> onLikeButtonTapped(bool isLiked) async {
    return !isLiked;
  }

  ScrollController _controller;
  int myindex = 0;
  double _ratingStar = 0;
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(1023, 255, 112, 5)
              : const Color.fromARGB(1023, 231, 231, 232),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      physics: const ScrollPhysics(),
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            //   pinned: false,
            expandedHeight: 450,
            elevation: 0,
            backgroundColor: Colors.transparent,
            stretch: true,
            title: AppBar(
                title: Text(trans(context, 'slae_details')),
                centerTitle: true,
                backgroundColor: Colors.transparent),
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 400,
                          viewportFraction: 1,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          //   enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          onPageChanged:
                              (int index, CarouselPageChangedReason reason) {
                            setState(() {
                              myindex = index;
                            });
                          },
                          pageViewKey:
                              const PageStorageKey<dynamic>('carousel_slider'),
                        ),
                        items: <String>["logo", "logo", "logo", "logo", "logo"]
                            .map((dynamic i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Stack(
                                children: <Widget>[
                                  Container(
                                    child: Image.asset(
                                      "assets/images/discountbackground.png",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 300,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.centerRight,
                                            end: Alignment.bottomRight,
                                            colors: <Color>[
                                              const Color(0x00FFFFFF),
                                              Colors.grey[200],
                                            ]),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Positioned(
                        left: 6,
                        top: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LikeButton(
                              size: 26,
                              likeBuilder: (bool isLiked) {
                                return Container(
                                  key: key,
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: !isLiked
                                        ? Colors.black.withOpacity(.5)
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  child: Image.asset(
                                    "assets/images/like.png",
                                    width: 10,
                                    height: 10,
                                  ),
                                );
                              },
                              likeCountPadding:
                                  const EdgeInsets.symmetric(vertical: 3),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              countBuilder: (int c, bool b, String count) {
                                return Text(
                                  count,
                                  style: const TextStyle(color: Colors.black),
                                );
                              },
                              likeCount: 50,
                              countPostion: CountPostion.bottom,
                              circleColor: CircleColor(
                                  start: Colors.white, end: Colors.purple),
                              onTap: (bool loved) {
                                return onLikeButtonTapped(loved);
                              },
                            ),
                            LikeButton(
                              size: 31,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              countBuilder: (int c, bool b, String count) {
                                return Text(
                                  count,
                                  style: const TextStyle(color: Colors.black),
                                );
                              },
                              likeCount: 50,
                              countPostion: CountPostion.bottom,
                              circleColor: CircleColor(
                                  start: Colors.blue, end: Colors.purple),
                              onTap: (bool loved) {
                                return onLikeButtonTapped(loved);
                              },
                              likeCountPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                            ),
                            const SizedBox(height: 6)
                          ],
                        ),
                      ),
                      Positioned(
                        top: 220,
                        right: 8,
                        height: 200,
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // padding: const EdgeInsets.all(0),
                          // physics: const ScrollPhysics(),
                          // shrinkWrap: true,
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerRight,
                                child: Column(
                                  children: <Widget>[
                                    for (int i = 0; i < 5; i++)
                                      if (i == myindex) ...<Widget>[
                                        const SizedBox(height: 3),
                                        circleBar(true),
                                      ] else ...<Widget>[
                                        const SizedBox(height: 3),
                                        circleBar(false),
                                      ]
                                  ],
                                )),
                            Container(
                                alignment: Alignment.centerRight,
                                child: RatingBar(
                                  onRatingChanged: (double rating) {
                                    setState(() => _ratingStar = rating);
                                    // TODO(mislem): use this var to send raiting to API
                                    print(_ratingStar);
                                  },
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                  halfFilledIcon: Icons.star_half,
                                  isHalfAllowed: true,
                                  filledColor: Colors.amberAccent,
                                  emptyColor: Colors.grey,
                                  halfFilledColor: Colors.orange[300],
                                  size: 20,
                                )),
                            const SizedBox(height: 8),
                            Text("Sale Name", style: styles.underHeadblack),
                            Row(
                              children: <Widget>[
                                Image.asset(
                                    "assets/images/redaddreess_icon.png",
                                    scale: 3.5,
                                    fit: BoxFit.cover),
                                const SizedBox(width: 8),
                                Text("City", style: styles.mystyle),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text("Discount Details",
                                style: styles.underHeadblack),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(0),
                    height: 70,
                    child: DraggableScrollbar.rrect(
                      backgroundColor: Colors.orange,
                      alwaysVisibleScrollThumb: true,
                      controller: _controller,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        controller: _controller,
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها. ولذلك يتم استخدام طريقة لوريم إيبسوم لأنها تعطي توزيعاَ طبيعياَ -إلى حد ما- للأحرف عوضاً عن استخدام  فتجعلها تبدو (أي الأحرف) وكأنها نص مقروء. العديد من برامح النشر المكتبي وبرامح تحرير صفحات الويب تستخدم لوريم إيبسوم بشكل إفتراضي كنموذج عن النص، وإذا قمت بإدخال  في أي محرك بحث ستظهر العديد من المواقع الحديثة العهد في نتائج البحث. على مدى السنين ظهرت نسخ جديدة ومختلفة من نص لوريم إيبسوم، أحياناً عن طريق الصدفة، وأحياناً عن عمد كإدخال بعض العبارات الفكاهية إليها.",
                                    style: styles.mystyle,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  // Container(
                  //   padding: const EdgeInsets.all(0),
                  //   height: 70,
                  //   alignment: Alignment.topCenter,
                  //   child: Scrollbar(
                  //     controller: _controller,
                  //     isAlwaysShown: true,
                  //     child: ListView(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16),
                  //       shrinkWrap: true,
                  //       children: <Widget>[
                  //         Row(
                  //           children: <Widget>[
                  //             Expanded(
                  //               child: Text(
                  //                 "هناك حقيقة مثبتة منذ زمن طويل وهي أن المحتوى المقروء لصفحة ما سيلهي القارئ عن التركيز على الشكل الخارجي للنص أو شكل توضع الفقرات في الصفحة التي يقرأها. ولذلك يتم استخدام طريقة لوريم إيبسوم لأنها تعطي توزيعاَ طبيعياَ -إلى حد ما- للأحرف عوضاً عن استخدام  فتجعلها تبدو (أي الأحرف) وكأنها نص مقروء. العديد من برامح النشر المكتبي وبرامح تحرير صفحات الويب تستخدم لوريم إيبسوم بشكل إفتراضي كنموذج عن النص، وإذا قمت بإدخال  في أي محرك بحث ستظهر العديد من المواقع الحديثة العهد في نتائج البحث. على مدى السنين ظهرت نسخ جديدة ومختلفة من نص لوريم إيبسوم، أحياناً عن طريق الصدفة، وأحياناً عن عمد كإدخال بعض العبارات الفكاهية إليها.",
                  //                 style: styles.mystyle,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
        ];
      },
      body: ListView(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        children: <Widget>[Text("heelo")],
      ),
    ));
  }
}
