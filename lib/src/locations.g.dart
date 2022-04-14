// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

//Region _$RegionFromJson(Map<String, dynamic> json) => Region(
      //coords: LatLng.fromJson(json['coords'] as Map<String, dynamic>),
      //id: json['id'] as String,
      //name: json['name'] as String,
      //zoom: (json['zoom'] as num).toDouble(),
    //);

//Map<String, dynamic> _$RegionToJson(Region instance) => <String, dynamic>{
      //'coords': instance.coords,
      //'id': instance.id,
      //'name': instance.name,
      //'zoom': instance.zoom,
    //};

Clinic _$ClinicFromJson(Map<String, dynamic> json) => Clinic(
      //address: json['address'] as String,
      //id: json['id'] as String,
      //image: json['image'] as String,
      //lat: (json['lat'] as num).toDouble(),
      //lng: (json['lng'] as num).toDouble(),
      //name: json['name'] as String,
      //phone: json['phone'] as String,
      //region: json['region'] as String,
      centerId: json['center_id'] as String,
      centerName: json['center_name'] as String,
      vacAddress: json['address'] as String,
      vacLatitude: (json['latitude'] as num).toDouble(),
      vacLongitude: (json['longitude'] as num).toDouble(),
      vaccineName: json['vaccine_name'] as String,
      amountLeft: json['amount_left'] as String,
      numPhone: json['phone'] as String,
    );

Map<String, dynamic> _$ClinicToJson(Clinic instance) => <String, dynamic>{
      //'address': instance.address,
      //'id': instance.id,
      //'image': instance.image,
      //'lat': instance.lat,
      //'lng': instance.lng,
      //'name': instance.name,
      //'phone': instance.phone,
      //'region': instance.region,
      'center_id': instance.centerId,
      'center_name': instance.centerName,
      'address': instance.vacAddress,
      'latitude': instance.vacLatitude,
      'longitude': instance.vacLongitude,
      'vaccine_name': instance.vaccineName,
      'amount_left': instance.amountLeft,
      'phone': instance.numPhone,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      clinics: (json['clinics'] as List<dynamic>)
          .map((e) => Clinic.fromJson(e as Map<String, dynamic>))
          .toList(),
      //regions: (json['regions'] as List<dynamic>)
          //.map((e) => Region.fromJson(e as Map<String, dynamic>))
          //.toList(),
    );

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'clinics': instance.clinics,
      //'regions': instance.regions,
    };
