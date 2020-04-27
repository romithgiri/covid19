import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:flutter/painting.dart';
import 'ConfigFile.dart' as cf;


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

  String img1 = 'images/icon4.png';
  String img2 = 'images/icon3.png';
  String img3 = 'images/icon2.png';
  String img4 = 'images/icon1.png';
  String img5 = 'images/piechart.png';
  String img6 = 'images/linechar.png';

  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.deepPurple,
    Colors.orange,
    Colors.brown,
  ];

  @override
  void initState() {
    var aa = cf.Size.screenWidth;
    print('11111111111 $aa');
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
    cf.Size.init(context);
    return Scaffold(
      backgroundColor: Colors.pinkAccent[700],
      body: SafeArea(
          child: toggle ? SingleChildScrollView(
              child: Column( children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.00),
                    ),
                    Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.white,
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(15.00),
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
                                  legendStyle: TextStyle(color: Colors.pinkAccent[700], fontSize: 10.00, fontFamily: 'Poppins', fontWeight: FontWeight.w300),
                                  decimalPlaces: 1,
                                  showChartValueLabel: true,
                                  initialAngle: 0,
                                  chartValueStyle: defaultChartValueStyle.copyWith(
                                    color: Colors.blueGrey[900].withOpacity(0.9),
                                    fontSize: 15.00,
                                  ),
                                  chartType: ChartType.ring,
                                )),
                            )
                        ),
                        PieChartCompWithRow(context, 'Total Confirmed', a, 'Total Deaths', b, img1, img2),
                        PieChartCompWithRow(context, 'Total Recovered', c, 'New Confirmed', d, img3,img4),
                        PieChartCompWithRow(context, 'New Deaths', e, 'New Recovered', f, img5, img6),
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.00),
                        ),
                  ]
              )
          ): Column(children: <Widget>[
            Center(
              child:
              Loading(indicator: BallPulseIndicator(), size: 100.0, color: Colors.white,),
            )
          ])
      )
    );
  }
}

Widget PieChartComp(BuildContext context, a, b, img) {
  // TODO: implement build
  return Container(
    width: cf.Size.screenWidth/2.1,
    height: cf.Size.screenHeight/4.8,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: Padding(
        padding: EdgeInsets.all(10.00),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                      a,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.pinkAccent[700], fontSize: 15.00, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                    )
                ),
                Expanded(
                  child: Text(
                    b,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 22.00, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                    child: Image(image: AssetImage(img))
                )
              ],
            )),
      )
    ),
  );
}

Widget PieChartCompWithRow(BuildContext context, a, b, c, d, imgOne, imgTwo) {
  // TODO: implement build
  return Container(
    padding: EdgeInsets.all(5.00),
    child: Row(
      children: <Widget>[
        PieChartComp(context, a, b, imgOne),
        Spacer(),
        PieChartComp(context, c, d, imgTwo)
      ],
    ),
  );
}

//Widget PieChartCompWithScroll(BuildContext context, a, b, c, d, e, f) {
//  return Container(
//      height: 100.0,
//      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
//        Row(children: <Widget>[PieChartCompWithRow(context, a, b, c, d)])
//      ]));
//}
