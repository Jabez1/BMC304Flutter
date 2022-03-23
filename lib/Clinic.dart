class Clinic {
  final String clinicId;
  final String name;
  final String description;
  final double longitude;
  final double latitude;

  Clinic({required this.clinicId, required this.name, required this.longitude,
    required this.latitude, required this.description});

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      clinicId: json['clinicID'],
      name: json['name'],
      description: json['description'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}