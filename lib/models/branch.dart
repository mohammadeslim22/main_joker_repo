import 'dart:ui';

class Branch {
  const Branch({
    this.id,
    this.title,
    this.address,
    this.display,
    this.imdb,
    this.gendres,
    this.desc,
  });
  final int id;
  final String title;
  final String address;
  final Color display;
  final double imdb;
  final String gendres;
  final String desc;
  static List<Branch> get branchData => const <Branch>[
         Branch(
            id: 0,
            title: "فرع الرياض",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 1,
            title: "فرع المدينة المنورة",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 2,
            title: "فرع جدة",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 3,
            title: "فرع مكة",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 4,
            title: "assets/images/shoptwo.jpg",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 5,
            title: "assets/images/shopone.jpg",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
         Branch(
            id: 6,
            title: "assets/images/shopone.jpg",
            address: "عنوان الفرع يوضع هنا منطقة - شارع - رقم "),
      ];
}
