class Clinic {
  final String centerId;
  final String centerName;
  final String vacAddress;
  final String vacLatitude;
  final String vacLongitude;
  final String vaccineName;
  final String amountLeft;
  final String numPhone;
  String? distance;


  Clinic({required this.centerId, required this.centerName,
    required this.vacAddress,required this.vacLatitude ,
    required this.vacLongitude, required this.vaccineName,
    required this.amountLeft, required this.numPhone});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      centerId: json['center_id'],
      centerName: json['center_name'],
      vacAddress: json['address'],
      vacLatitude: json['latitude'],
      vacLongitude: json['longitude'],
      vaccineName: json['vaccine_name'],
      amountLeft: json['amount_left'],
      numPhone: json['phone'],
    );
  }
  
  void setDistance(String distance){
    this.distance=distance;
  }

  String getString() {
    return this.centerName;
  }

  String getId()
  {
    return this.centerId;
  }

  String getAddress() {
    return this.vacAddress;
  }

  String getLadtitude() {
    return this.vacLatitude;
  }

  String getLongitude() {
    return this.vacLongitude;
  }

  String getVaccineName() {
    return this.vaccineName;
  }

  String getPhone() {
    return this.numPhone;
  }

  String getAmountLeft() {
    return this.amountLeft;
  }

}