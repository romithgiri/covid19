import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];

  @override
  void initState() async {
    super.initState();
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    var client = new http.Client();
    try {
      print('bbbbbbbbbbbbbbbbbbbb');
      print(client.get('https://api.covid19api.com/summary'));
      print('dddddddddddddddd');
    }
    finally {
      client.close();
    }

    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlueAccent,
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(8.0),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 800),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery.of(context).size.width / 2.7,
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.grey[200],
                  colorList: colorList,
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  decimalPlaces: 1,
                  showChartValueLabel: true,
                  initialAngle: 0,
                  chartValueStyle: defaultChartValueStyle.copyWith(
                    color: Colors.blueGrey[900].withOpacity(0.9),
                  ),
                  chartType: ChartType.disc,
                )),
            PieChartCompWithRow(context, 'One'),
            Spacer(),
            PieChartCompWithRow(context, 'One'),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void togglePieChart() {
    setState(() {
      toggle = !toggle;
    });
  }
}

Widget PieChartComp(BuildContext context, ot) {
  // TODO: implement build
  return Container(
    width: 200.00,
    height: 150.00,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.orangeAccent,
      elevation: 10,
      child: Center(
        child: Text(
          ot,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Widget PieChartCompWithRow(BuildContext context, ot) {
  // TODO: implement build
  return Container(
    padding: EdgeInsets.all(5.00),
    child: Row(
      children: <Widget>[
        PieChartComp(context, ot),
        Spacer(),
        PieChartComp(context, ot),
      ],
    ),
  );
}

Widget PieChartCompWithScroll(BuildContext context, ot) {
  // TODO: implement build
  return Container(
      height: 100.0,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Row(
            children: <Widget>[
                PieChartCompWithRow(context,ot)
            ])
          ]
      )
  );
}
