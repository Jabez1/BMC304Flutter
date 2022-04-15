import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import '../main.dart';
import 'ViewDeaths.dart';
import 'ViewCovid.dart';

class CasesCharts extends StatelessWidget {
  Future<List<CovidCase>> futureCovidCases = fetchCovid();
  Future<List<DeathCase>> futureDeathCases = fetchDeaths();

  //Creates Lists for the ChartMaker whilst changing the bar color depending on the values
  List<CaseSeries> createCovidChartList(List<CovidCase> covidCases){
    List<CaseSeries> coloredList = [];
    List<CovidCase> covidList =  covidCases;

    for (var i = 0; i < covidList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      if(covidList[i].deathCount > 100){
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.red);
      }
      else{
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.blue);
      }
      coloredList.add(CaseSeries(
          date: DateFormat('d-M').format(covidList[i].deathDate),
          count: covidList[i].deathCount,
          barColor: tempBarColor
      ));
    }
    return coloredList;
  }

  List<CaseSeries> createCovidMonthlyChartList(List<CovidCase> covidCases){
    List<CaseSeries> monthlyList = [];
    List<CovidCase> covidList =  covidCases;

    for(var i = 0; i < covidList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      //total deaths per month, resets each month
      int totalCases = 0;
      for(var j = 0; j < covidList.length; j++){
        //Checks if in the list has another covidcase in the same year and month
        //Values that have already been checked and added will have a caseCount of less than 0
        if(covidList[i].deathDate.year == covidList[j].deathDate.year &&
            covidList[i].deathDate.month == covidList[j].deathDate.month &&
            covidList[i].deathCount > 0 && covidList[j].deathCount > 0) {
          totalCases += covidList[j].deathCount;

          if(i!=j) {
            //If the item is NOT comparing with itself, set deathCount to 0 to avoid repetition
            covidList[j].deathCount = -1;
          }
        }
      }
      //If the totalDeaths remains as 0, do not add to the list
      if(totalCases != 0) {
        //If totalDeaths are more than 500, make the bar red
        if (totalCases > 10000) {
          tempBarColor = charts.ColorUtil.fromDartColor(Colors.red);
        }
        else {
          tempBarColor = charts.ColorUtil.fromDartColor(Colors.blue);
        }
        monthlyList.add(CaseSeries(
            date: DateFormat('M-yy').format(covidList[i].deathDate),
            count: totalCases,
            barColor: tempBarColor
        ));
      }
    }
    return monthlyList;
  }

  List<CaseSeries> createChartList(List<DeathCase> deathCases){
    List<CaseSeries> coloredList = [];
    List<DeathCase> deathList =  deathCases;

    for (var i = 0; i < deathList.length; i++) {
      var tempBarColor =  charts.ColorUtil.fromDartColor(Colors.white);
      if(deathList[i].deathCount > 100){
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.red);
      }
      else{
        tempBarColor =  charts.ColorUtil.fromDartColor(Colors.blue);
      }
      coloredList.add(CaseSeries(
          date: DateFormat('d-M').format(deathList[i].deathDate),
          count: deathList[i].deathCount,
          barColor: tempBarColor
      ));
    }
    return coloredList;
  }

  List<CaseSeries> createMonthlyChartList(List<DeathCase> deathCases){
    List<CaseSeries> monthlyList = [];
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
        monthlyList.add(CaseSeries(
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
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text("Covid Deaths"),
              bottom: TabBar(
                  tabs:[
                    Tab(icon: Icon(Icons.edit)),
                    Tab(icon: Icon(Icons.edit)),
                  ]
              )
          ),
          body:  TabBarView(
              children : <Widget>[
                FutureBuilder <List<CovidCase>?>(
                    future: futureCovidCases,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                            child: CasesChartMaker(
                              data: createCovidChartList(snapshot.data as List<CovidCase>),
                              monthlyData : createCovidMonthlyChartList(snapshot.data as List<CovidCase>),
                            )
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    }
                ),
                FutureBuilder <List<DeathCase>?>(
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
              ]
          )
      ),
    );
  }
}


class CasesChartMaker extends StatelessWidget {
  final List<CaseSeries> data;
  final List<CaseSeries> monthlyData;

  CasesChartMaker({required this.data, required this.monthlyData});


  @override
  Widget build(BuildContext context) {
    List<charts.Series<CaseSeries, String>> series = [
      charts.Series(
          id: "Deaths",
          data: data,
          domainFn: (CaseSeries series, _) => series.date,
          measureFn: (CaseSeries series, _) => series.count,
          colorFn: (CaseSeries series, _) => series.barColor
      )
    ];
    
    List<charts.Series<CaseSeries, String>> monthlySeries = [
      charts.Series(
          id: "Deaths",
          data: monthlyData,
          domainFn: (CaseSeries series, _) => series.date,
          measureFn: (CaseSeries series, _) => series.count,
          colorFn: (CaseSeries series, _) => series.barColor
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


class CaseSeries {
  final String date;
  final int count;
  final charts.Color barColor;

  CaseSeries(
      {
        required this.date,
        required this.count,
        required this.barColor
      }
      );
}
