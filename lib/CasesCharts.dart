import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'ViewCases.dart';

class CasesCharts extends StatelessWidget {
  Future<List<DeathCase>> futureDeathCases = fetchData();

  Future<List<DeathCaseSeries>> createChartList(Future <List<DeathCase>> deathCases) async{
    List<DeathCaseSeries> coloredList = [];
    List<DeathCase> deathList = await deathCases;

    for (var i = 0; i < deathList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      if(deathList[i].deathCount > 1000){
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.red);
        print(deathList[i].deathDate);
      }
      else{
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.blue);
      }
      print(coloredList.length);
      coloredList.add(DeathCaseSeries(
          date: DateFormat('MM-dd').format(deathList[i].deathDate),
          count: deathList[i].deathCount,
          barColor: tempBarColor
      ));
    }
    return coloredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Covid Deaths"),
      ),
      body: FutureBuilder <List<DeathCaseSeries>?>(
        future: createChartList(futureDeathCases),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: CasesChartMaker(
                  data: snapshot.data as List<DeathCaseSeries>,
                )
            );
            } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
           }
          return CircularProgressIndicator();
        }
          ),
    );
  }
}


class CasesChartMaker extends StatelessWidget {
  final List<DeathCaseSeries> data;

  CasesChartMaker({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DeathCaseSeries, String>> series = [
      charts.Series(
          id: "Deaths",
          data: data,
          domainFn: (DeathCaseSeries series, _) => series.date,
          measureFn: (DeathCaseSeries series, _) => series.count,
          colorFn: (DeathCaseSeries series, _) => series.barColor
      )
    ];

    return Container(
      height: 500,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Covid Deaths for the past few days",
                //style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class DeathCaseSeries {
  final String date;
  final int count;
  final charts.Color barColor;

  DeathCaseSeries(
      {
        required this.date,
        required this.count,
        required this.barColor
      }
      );
}


