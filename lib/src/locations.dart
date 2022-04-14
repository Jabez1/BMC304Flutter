import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    required this.latitude,
    required this.longitude,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double latitude;
  final double longitude;
}

@JsonSerializable()
//class Region {
  //Region({
    //required this.coords,
    //required this.id,
    //required this.name,
    //required this.zoom,
  //});

  //factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
  //Map<String, dynamic> toJson() => _$RegionToJson(this);

  //final LatLng coords;
  //final String id;
  //final String name;
  //final double zoom;
//}

@JsonSerializable()
class Clinic {
  Clinic({
    required this.centerId,
    required this.centerName,
    required this.vacAddress,
    required this.vacLatitude ,
    required this.vacLongitude,
    required this.vaccineName,
    required this.amountLeft,
    required this.numPhone,
    //required this.region,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) => _$ClinicFromJson(json);
  Map<String, dynamic> toJson() => _$ClinicToJson(this);

  final String centerId;
  final String centerName;
  final String vacAddress;
  final double vacLatitude;
  final double vacLongitude;
  final String vaccineName;
  final String amountLeft;
  final String numPhone;
  //final String region;
}

@JsonSerializable()
class Locations {
  Locations({
    required this.clinics,
    //required this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Clinic> clinics;
  //final List<Region> regions;
}

Future<Locations> getClinics() async {
  const googleLocationsURL = 'http://192.168.1.105:8080/convtjson.php';

  // Retrieve the locations of Google clini
  try {
    final response = await http.post(Uri.parse(googleLocationsURL));
    if (response.statusCode == 200) {
      return Locations.fromJson(json.decode(response.body));
    }
  } catch (e) {
    print(e);
  }

  // Fallback for when the above HTTP request fails.
  return Locations.fromJson(
    json.decode(
      await rootBundle.loadString('assets/convtjson.php'),
    ),
  );
}