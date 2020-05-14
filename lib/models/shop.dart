import 'dart:ui';

class Shop {


 const Shop(
      {this.id,
      this.title,
      this.image,
      this.display,
      this.imdb,
      this.gendres,
      this.desc});
  final int id;
  final  String title;
  final  String image;
  final  Color display;
 final   double imdb;
 final   String gendres;
  final  String desc;


  //  Shop fromJson(Map<String, dynamic> json) {
  //  return Shop(
  //  id: id = json['cat_note'] as int,
  //  title: title = json['cat_todo'] as String,
  //  image: image = json['cat_rem'] as String,
  // display:  display = json['cat_tag'] as Color,
  // gendres:  gendres = json['cat_urgent'] as String,
  // imdb:  imdb = json['cat_work'] as double,
  //  desc: desc = json['cat_office'] as String,
    
  //  );
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data =  <String, dynamic>{};
  //   data['cat_note'] = id;
  //   data['cat_todo'] = title;
  //   data['cat_rem'] = image;
  //   data['cat_tag'] = display;
  //   data['cat_urgent'] = gendres;
  //   data['cat_work'] = imdb;
  //   data['cat_office'] = desc;
    
  //   return data;
  // }
  static List<Shop> get movieData => const <Shop>[
         Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
                 Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
                 Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
                 Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
                 Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
                 Shop(
          image: "assets/images/shopone.jpg",
        ),
         Shop(
          image: "assets/images/shoptwo.jpg",

        ),
         Shop(
           
            image: "assets/images/shopone.jpg",
        ),
             ];
}
