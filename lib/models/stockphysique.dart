class Stockphysique {
  final String fishname;
  final double stocknumber;
  Stockphysique({required this.fishname, required this.stocknumber});

  factory Stockphysique.fromMap(Map<String, dynamic> map) {
    return Stockphysique(
        fishname: map["fishname"],
        stocknumber: double.parse(map["stocknumber"]));
  }
}
