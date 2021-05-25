import 'dart:ffi';

class Stockphysique {
  final String fishname;
  final double stocknumber;
  Stockphysique({this.fishname, this.stocknumber});

  factory Stockphysique.fromMap(Map<String, dynamic> map) {
    return Stockphysique(
        fishname: map["fishname"],
        stocknumber: double.parse(map["stocknumber"]));
  }
}
