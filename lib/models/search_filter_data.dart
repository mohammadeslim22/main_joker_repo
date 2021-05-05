class FilterData {
  FilterData(
      {this.merchantNameOrPartOfit,
      this.saleNameOrPartOfit,
      this.startingdate,
      this.endingdate,
      this.rating,
      this.specifications,
      this.fromPrice,
      this.toPrice});
  final String merchantNameOrPartOfit;
  final String saleNameOrPartOfit;
  final DateTime startingdate;
  final DateTime endingdate;
  final double fromPrice;
  final double toPrice;
  final double rating;
  final List<int> specifications;

  @override
  String toString() {
    return "$merchantNameOrPartOfit  +  $saleNameOrPartOfit  + ${startingdate.toLocal().toString()}  + ${endingdate.toLocal().toString()}+ $rating  +$specifications";
  }
}
