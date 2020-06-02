class FilterData{
  FilterData(this.merchantNameOrPartOfit, this.saleNameOrPartOfit, this.startingdate, this.endingdate, this.lat, this.long, this.rating, this.specifications);
  final String merchantNameOrPartOfit;
  final String saleNameOrPartOfit;
  final DateTime startingdate;
  final DateTime endingdate;
  final double lat;
  final double long;
  final double rating;
  final List<int> specifications;


  @override
  String toString() {
    return "$merchantNameOrPartOfit  +  $saleNameOrPartOfit  + ${startingdate..toLocal().toString()}  + ${endingdate.toLocal().toString()} +  $lat  +$long  + $rating  +$specifications";
  }
  
}