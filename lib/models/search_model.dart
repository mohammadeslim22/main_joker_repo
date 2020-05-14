class SearchModel {


  SearchModel({
    this.id,
    this.search,
  });
    int id;
  String search;
  static List<SearchModel> get searchData => <SearchModel>[
        
        SearchModel(id: 1, search: "أزياء"),
        SearchModel(id: 2, search: "تجميل"),
        SearchModel(id: 3, search: "مطاعم"),
        SearchModel(id: 4, search: "صالات رياضة"),
        SearchModel(id: 5, search: "صيدليات"),
        SearchModel(id: 6, search: "سوبر ماركت"),
        SearchModel(id: 7, search: "عروض سفر"),
        SearchModel(id: 8, search: "شقق سكنية"),
        SearchModel(id: 9, search: "صيانة"),
        SearchModel(id: 10, search: "معدات"),
        SearchModel(id: 11, search: "أدوات منزلية"),
        SearchModel(id: 12, search: "اللغة العربية فيه االكتثير من الحروف"),
      ];
}
