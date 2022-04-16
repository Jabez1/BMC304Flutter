import 'package:intl/intl.dart';

class Case{
  final DateTime deathDate;
  final int deathCount;

  Case({required this.deathDate, required this.deathCount});

  String getDeathDate(){
    return DateFormat('yyyy-MM-dd').format(this.deathDate);
  }
}
class DeathCase extends Case {
  DeathCase({ required DateTime deathDate, required int deathCount})
      : super(deathDate:deathDate, deathCount: deathCount);

  factory DeathCase.fromJson(Map<String, dynamic> json) {
    return DeathCase(
      deathDate: DateTime.parse(json['deathDate']),
      deathCount: int.parse(json['deathCount']),
    );
  }
}

class CovidCase extends Case {
  CovidCase({ required DateTime deathDate, required int deathCount})
      : super(deathDate: deathDate, deathCount: deathCount);

  factory CovidCase.fromJson(Map<String, dynamic> json) {
    return CovidCase(
      deathDate: DateTime.parse(json['covidDate']),
      deathCount: int.parse(json['covidCount']),
    );
  }
}
