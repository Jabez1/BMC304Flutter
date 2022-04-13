import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'main.dart';
import 'ViewCases.dart';

class CasesCharts extends StatelessWidget {
  Future<List<DeathCase>> futureDeathCases = fetchData();

  List<DeathCaseSeries> createChartList(List<DeathCase> deathCases){
    List<DeathCaseSeries> coloredList = [];
    List<DeathCase> deathList =  deathCases;

    for (var i = 0; i < deathList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      if(deathList[i].deathCount > 100){
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.red);
      }
      else{
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.blue);
      }
      coloredList.add(DeathCaseSeries(
          date: DateFormat('d-M').format(deathList[i].deathDate),
          count: deathList[i].deathCount,
          barColor: tempBarColor
      ));
    }
    return coloredList;
  }

  List<DeathCaseSeries> createMonthlyChartList(List<DeathCase> deathCases){
    List<DeathCaseSeries> monthlyList = [];
    List<DeathCase> deathList =  deathCases;

    for(var i = 0; i < deathList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      //total deaths per month, resets each month
      int totalDeaths = 0;
      for(var j = 0; j < deathList.length; j++){
        //Checks if in the list has another deathCase in the same year and month
        //Values that have already been checked and added will have a deathCount of less than 0
        if(deathList[i].deathDate.year == deathList[j].deathDate.year &&
           deathList[i].deathDate.month == deathList[j].deathDate.month &&
           deathList[i].deathCount > 0 && deathList[j].deathCount > 0) {
          totalDeaths += deathList[j].deathCount;

          if(i!=j) {
            //If the item is NOT comparing with itself, set deathCount to 0 to avoid repetition
            deathList[j].deathCount = -1;
          }
        }
      }
      //If the totalDeaths remains as 0, do not add to the list
      if(totalDeaths != 0) {
        //If totalDeaths are more than 500, make the bar red
        if (totalDeaths > 500) {
          tempBarColor = charts.ColorUtil.fromDartColor(Colors.red);
        }
        else {
          tempBarColor = charts.ColorUtil.fromDartColor(Colors.blue);
        }
        monthlyList.add(DeathCaseSeries(
            date: DateFormat('M-yy').format(deathList[i].deathDate),
            count: totalDeaths,
            barColor: tempBarColor
        ));
      }
    }
    return monthlyList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Covid Deaths"),
      ),
      body: FutureBuilder <List<DeathCase>?>(
        future: futureDeathCases,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
                child: CasesChartMaker(
                  data: createChartList(snapshot.data as List<DeathCase>),
                  monthlyData : createMonthlyChartList(snapshot.data as List<DeathCase>),
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
  final List<DeathCaseSeries> monthlyData;

  CasesChartMaker({required this.data, required this.monthlyData});


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
    
    List<charts.Series<DeathCaseSeries, String>> monthlySeries = [
      charts.Series(
          id: "Deaths",
          data: monthlyData,
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
              ),
              Text(
                "Covid Deaths for the past few months",
                //style: Theme.of(context).textTheme.bodyText2,
              ),
              Expanded(
                child: charts.BarChart(monthlySeries, animate: true),
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


