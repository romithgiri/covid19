import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:jiffy/jiffy.dart';
import 'ConfigFile.dart' as cf;

class CountryList extends StatefulWidget {
  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class CountryDataCls {
  final String country;
  final String countryCode;
  final String slug;
  final String newConfirmed;
  final String totalConfirmed;
  final String newDeaths;
  final String totalDeaths;
  final String newRecovered;
  final String totalRecovered;
  final String date;

  CountryDataCls({
    this.country,
    this.countryCode,
    this.slug,
    this.newConfirmed,
    this.totalConfirmed,
    this.newDeaths,
    this.totalDeaths,
    this.newRecovered,
    this.totalRecovered,
    this.date,
  });

  factory CountryDataCls.fromJson(Map<String, dynamic> json) {
    return new CountryDataCls(
        country: json['Country'].toString(),
        countryCode: json['CountryCode'].toString(),
        slug: json['Slug'].toString(),
        newConfirmed: json['NewConfirmed'].toString(),
        totalConfirmed: json['TotalConfirmed'].toString(),
        newDeaths: json['NewDeaths'].toString(),
        totalDeaths: json['TotalDeaths'].toString(),
        newRecovered: json['NewRecovered'].toString(),
        totalRecovered: json['TotalRecovered'].toString(),
        date: Jiffy(json['Date']).format("MMMM do yyyy, h:mm:ss a"));
  }
}

class _CountryListPageState extends State<CountryList> {
  bool toggle = false;
  var data = [];
  var dataCount;
  List<CountryDataCls> dataFromServer = List();
  List<CountryDataCls> filterData = List();

  List<Color> colorList = [
    Color(0xFF69D2E7),
    Color(0xFF7FC7AF),
    Color(0xFFDAD8A7)
  ];

  List<Color> colorList2 = [
    Color(0xFFFF9E9D),
    Color(0xFFFFAC5D),
    Color(0xFFF2DE6E),
  ];

  @override
  void initState() {
    super.initState();
    asyncOperation().then((val) {}).catchError((error, stackTrace) {});
  }

  Future<List<CountryDataCls>> asyncOperation() async {
    http.Response response =
        await http.get('https://api.covid19api.com/summary');
    var responseJson = json.decode(response.body);
    setState(() {
      dataFromServer = (responseJson['Countries'] as List)
          .map((p) => CountryDataCls.fromJson(p))
          .toList();
      filterData = dataFromServer;
    });
    await toggleLoader();
    return dataFromServer = (responseJson['Countries'] as List)
        .map((p) => CountryDataCls.fromJson(p))
        .toList();
  }

  Future<void> toggleLoader() async {
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
            child: Column(children: <Widget>[
              Column(children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              filterData = dataFromServer
                                  .where((u) => (u.country
                                      .toLowerCase()
                                      .contains(value.toLowerCase())))
                                  .toList();
                            });
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search,
                                  color: Color(0xFFE511E5), size: 25.0),
                              contentPadding:
                                  EdgeInsets.only(left: 10.0, top: 12.0),
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey))),
                    ))
              ]),
              Padding(
                padding: EdgeInsets.only(bottom: 10.00),
              ),
              Expanded(
                  child: toggle
                      ? Padding(padding: EdgeInsets.only(left: 5, right: 5),child: getListView())
                      : Column(children: <Widget>[
                          Center(
                            child: Loading(
                              indicator: BallPulseIndicator(),
                              size: 100.0,
                              color: Colors.white,
                            ),
                          )
                        ]))
            ])));
  }

  Widget getListView() {
    var listItems = filterData;
    var listview = ListView.builder(
        itemCount: filterData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                listItems[index].country,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.pinkAccent[700],
                                    fontSize: 20.00,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  listItems[index].date.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.00,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w200),
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            horizontalScrolCard(
                              context,
                              'Total Confirmed',
                              'Total Recovered',
                              'Total Deaths',
                              colorList,
                              listItems[index].totalConfirmed,
                              listItems[index].totalRecovered,
                              listItems[index].totalDeaths,
                            ),
                            horizontalScrolCard(
                              context,
                              'New Confirmed',
                              'New Recovered',
                              'New Deaths',
                              colorList2,
                              listItems[index].newConfirmed,
                              listItems[index].newRecovered,
                              listItems[index].newDeaths,
                            ),
                          ],
                        )
                    )
                ),
              ),
            ],
          );
        });
    return listview;
  }
}

Widget horizontalScrolCard(BuildContext context, strConfirmed, strRecovered, strDeaths, colorList, valConfirmed, valRecovered, valDeaths) {
  cf.Size.init(context);
  return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      height: cf.Size.screenHeight / 4.5,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        Container(
          child: countryCard(context, colorList[0], strConfirmed, valConfirmed),
        ),
        Container(
          child: countryCard(context, colorList[1], strRecovered, valRecovered),
        ),
        Container(
          child: countryCard(context, colorList[2], strDeaths, valDeaths),
        )
      ]));
}

//Widget finalCardCall(BuildContext context) {
//  // TODO: implement build
//  cf.Size.init(context);
//  return Container(
//      color: Colors.deepPurple,
//      width: cf.Size.screenWidth,
//      child: Container(
//        width: cf.Size.screenWidth,
//        child: Column(
//          children: <Widget>[
//            Container(
//              width: cf.Size.screenWidth,
//              color: Colors.green,
//              child: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: countryCard(context),
//                  ),
//                  Expanded(
//                    child: countryCard(context),
//                  )
//                ],
//              ),
//            ),
//          ],
//        ),
//      ));
//}

Widget countryCard(BuildContext context, colorList, strTitle, valData) {
  // TODO: implement build
  cf.Size.init(context);
  return Container(
      width: cf.Size.screenWidth / 2.6,
      child: Align(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Wrap(
              children: <Widget>[
                Text(
                  strTitle,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.00,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w200),
                )
              ],
            ),
            Container(
              width: cf.Size.screenWidth / 2.6,
              height: cf.Size.screenHeight / 5.5,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    valData,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.00,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w200),
                  )),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: colorList,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
            )
          ])));
}
