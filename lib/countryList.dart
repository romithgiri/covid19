import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

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
      date: json['Date'].toString(),
    );
  }
}

class _CountryListPageState extends State<CountryList> {
  TextEditingController _textController = TextEditingController();
  bool toggle = false;
  var data = [];
  var dataCount;
  List<CountryDataCls> dataFromServer = List();
  List<CountryDataCls> filterData = List();

  @override
  void initState() {
    super.initState();
    asyncOperation().then((val) {}).catchError((error, stackTrace) {});
  }

  Future<List<CountryDataCls>> asyncOperation() async {
    http.Response response = await http.get('https://api.covid19api.com/summary');
    var responseJson = json.decode(response.body);
    setState(() {
      dataFromServer = (responseJson['Countries'] as List).map((p) => CountryDataCls.fromJson(p)).toList();
      filterData = dataFromServer;
    });
    await toggleLoader();
    return  dataFromServer = (responseJson['Countries'] as List).map((p) => CountryDataCls.fromJson(p)).toList();
  }

  Widget getListView() {
    var listItems = filterData;
    var listview = ListView.builder(
        itemCount: filterData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
              width: 200.00,
              height: 150.00,
              padding: EdgeInsets.all(6.00),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(10.00),
                      child: Text(
                        listItems[index].country,
                        style: TextStyle(
                            color: Colors.pinkAccent[700],
                            fontSize: 20.00,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500),
                      )
                  )
              )
          );
        });
    return listview;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.pinkAccent[700],
            child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Search Here...',
                      ),
                      onChanged: (value){
                        setState((){
                          filterData = dataFromServer
                              .where((u) => (u.country
                              .toLowerCase()
                              .contains(value.toLowerCase())
                          )).toList();
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child:
                      toggle ? getListView()
                          : Column(children: <Widget>[
                        Center(
                          child: Loading(
                            indicator: BallPulseIndicator(),
                            size: 100.0,
                            color: Colors.white,
                          ),
                        )
                      ])
                  )
                ])
        )
    );
  }

  Future<void> toggleLoader() async {
    setState(() {
      toggle = !toggle;
      return 0;
    });
  }
}
