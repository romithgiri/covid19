import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  bool toggle = false;
  String a = '';
  String b = '';
  String c = '';
  String d = '';
  String e = '';
  String f = '';

  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.yellow[400],
    Colors.lightBlueAccent,
    Colors.lightGreen,
    Colors.red[100],
    Colors.greenAccent,
    Colors.tealAccent,
  ];

  @override
  void initState() {
    print('11111111111');
    super.initState();
    asyncOperation().then((val) {
      print('22222222222222');
    }).catchError((error, stackTrace) {
      print("33333333333333: $error");
    });
  }

  Future<void> asyncOperation() async {
//    setState(() {
//    });
    var url = 'https://api.covid19api.com/summary';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);

      a = nullValueCheck(jsonResponse['Global']['TotalConfirmed']).toString();
      b = nullValueCheck(jsonResponse['Global']['TotalDeaths']).toString();
      c = nullValueCheck(jsonResponse['Global']['TotalRecovered']).toString();
      d = nullValueCheck(jsonResponse['Global']['NewConfirmed']).toString();
      e = nullValueCheck(jsonResponse['Global']['NewDeaths']).toString();
      f = nullValueCheck(jsonResponse['Global']['NewRecovered']).toString();

      dataMap.putIfAbsent("Total Confirmed",
          () => jsonResponse['Global']['TotalConfirmed'] + 00.00);
      dataMap.putIfAbsent(
          "Total Deaths", () => jsonResponse['Global']['TotalDeaths'] + 00.00);
      dataMap.putIfAbsent("Total Recovered",
          () => jsonResponse['Global']['TotalRecovered'] + 00.00);
      dataMap.putIfAbsent("New Confirmed",
          () => jsonResponse['Global']['NewConfirmed'] + 00.00);
      dataMap.putIfAbsent(
          "New Deaths", () => jsonResponse['Global']['NewDeaths'] + 00.00);
      dataMap.putIfAbsent("New Recovered",
          () => jsonResponse['Global']['NewRecovered'] + 00.00);

      await togglePieChart();
      return 0;
    } else {
      print('5555555555555555555555555555: ${response.statusCode}.');
      return 0;
    }
  }

  int nullValueCheck(data) {
    if (data == '' || data == null) {
      return 0;
    } else {
      return data;
    }
  }

  Future<void> togglePieChart() async {
    setState(() {
      toggle = !toggle;
      return 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.pinkAccent[700],
          child: toggle
              ? Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: PieChart(
                          dataMap: dataMap,
                          animationDuration: Duration(milliseconds: 800),
                          chartLegendSpacing: 32.0,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          showChartValuesInPercentage: true,
                          showChartValues: true,
                          showChartValuesOutside: false,
                          chartValueBackgroundColor: Colors.grey[200],
                          colorList: colorList,
                          showLegends: true,
                          legendPosition: LegendPosition.right,
                          legendStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                          decimalPlaces: 1,
                          showChartValueLabel: true,
                          initialAngle: 0,
                          chartValueStyle: defaultChartValueStyle.copyWith(
                            color: Colors.blueGrey[900].withOpacity(0.9),
                            fontSize: 15.00,
                          ),
                          chartType: ChartType.ring,
                        )),
                    PieChartCompWithRow(
                        context, 'Total Confirmed', a, 'Total Deaths', b),
                    Spacer(),
                    PieChartCompWithRow(
                        context, 'Total Recovered', c, 'New Confirmed', d),
                    Spacer(),
                  ],
                )
              : Column(children: <Widget>[
                  Center(
                    child:
                        Loading(indicator: BallPulseIndicator(), size: 100.0, color: Colors.white,),
                  )
                ])),
    );
  }
}

Widget PieChartComp(BuildContext context, a, b) {
  // TODO: implement build
  return Container(
    width: 200.00,
    height: 150.00,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            a,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.pinkAccent[700], fontSize: 20.00, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
          ),
          Text(
            b,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 22.00, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
          ),
        ],
      )),
    ),
  );
}

Widget PieChartCompWithRow(BuildContext context, a, b, c, d) {
  // TODO: implement build
  return Container(
    padding: EdgeInsets.all(5.00),
    child: Row(
      children: <Widget>[
        PieChartComp(context, a, b),
        Spacer(),
        PieChartComp(context, c, d),
      ],
    ),
  );
}

Widget PieChartCompWithScroll(BuildContext context, a, b, c, d) {
  // TODO: implement build
  return Container(
      height: 100.0,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        Row(children: <Widget>[PieChartCompWithRow(context, a, b, c, d)])
      ]));
}
