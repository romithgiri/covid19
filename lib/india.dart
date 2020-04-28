import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'timeLineView.dart';
import 'ConfigFile.dart' as cf;

class OwnCountryList extends StatefulWidget {
  @override
  _OwnCountryListPageState createState() => _OwnCountryListPageState();
}

class OwnCountryDataCls {
  final String active;
  final String confirmed;
  final String deaths;
  final String deltaconfirmed;
  final String deltadeaths;
  final String deltarecovered;
  final String lastupdatedtime;
  final String recovered;
  final String state;
  final String statecode;
  final String statenotes;

  OwnCountryDataCls({
    this.active,
    this.confirmed,
    this.deaths,
    this.deltaconfirmed,
    this.deltadeaths,
    this.deltarecovered,
    this.lastupdatedtime,
    this.recovered,
    this.state,
    this.statecode,
    this.statenotes,
  });

  factory OwnCountryDataCls.fromJson(Map<String, dynamic> json) {
    return new OwnCountryDataCls(
        active: json['active'].toString(),
        confirmed: json['confirmed'].toString(),
        deaths: json['deaths'].toString(),
        deltaconfirmed: json['deltaconfirmed'].toString(),
        deltadeaths: json['deltadeaths'].toString(),
        deltarecovered: json['deltarecovered'].toString(),
        recovered: json['recovered'].toString(),
        state: json['state'].toString(),
        statecode: json['statecode'].toString(),
        statenotes: json['statenotes'].toString(),
        lastupdatedtime: json['lastupdatedtime']
//        lastupdatedtime: Jiffy(json['lastupdatedtime']).format("MMMM do yyyy, h:mm:ss a")
    );
  }
}

class _OwnCountryListPageState extends State<OwnCountryList> {
  bool toggle = false;
  var data = [];
  var dataCount;
  List<OwnCountryDataCls> dataFromServer = List();
  List<OwnCountryDataCls> filterData = List();

  List<Color> colorList = [
    Colors.indigoAccent,
    Colors.green,
    Colors.orange
  ];

  List<Color> colorList2 = [
    Colors.blue,
    Colors.lightGreen,
    Colors.deepOrange,
  ];

  @override
  void initState() {
    super.initState();
    asyncOperation().then((val) {}).catchError((error, stackTrace) {});
  }

  Future<List<OwnCountryDataCls>> asyncOperation() async {
    http.Response response = await http.get('https://api.covid19india.org/data.json');
    var responseJson = json.decode(response.body);
    setState(() {
      dataFromServer = (responseJson['statewise'] as List).map((p) => OwnCountryDataCls.fromJson(p)).toList();
      filterData = dataFromServer;
    });
    await toggleLoader();
    return dataFromServer = (responseJson['statewise'] as List).map((p) => OwnCountryDataCls.fromJson(p)).toList();
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
            color: Colors.white,
//            color: Colors.pinkAccent[700],
            child: Column(children: <Widget>[
              Column(children: <Widget>[
                Padding(
                    padding:
                    EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0),
                    child: Material(
                      elevation: 15.0,
                      borderRadius: BorderRadius.circular(30.0),
                      child: TextField(
                          onChanged: (value) {
                            setState(() {
                              filterData = dataFromServer
                                  .where((u) => (u.state
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
                        color: Colors.pink[600],
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
                    elevation: 15,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                listItems[index].state,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.pinkAccent[700],
                                    fontSize: cf.Size.blockSizeHorizontal*4.5,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Last updated time : ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: cf.Size.blockSizeHorizontal*3.9,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w200),
                                    ),
                                    Text(
                                      listItems[index].lastupdatedtime.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: cf.Size.blockSizeHorizontal*3.9,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w200),
                                    )
                                  ],
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_drop_down_circle,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        'Active Case :',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: cf.Size.blockSizeHorizontal*3.9,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        listItems[index].active.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: cf.Size.blockSizeHorizontal*3.9,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w700),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            horizontalScrolCard(
                              context,
                              'Total Confirmed',
                              'Total Recovered',
                              'Total Deaths',
                              colorList,
                              listItems[index].confirmed,
                              listItems[index].recovered,
                              listItems[index].deaths,
                            ),
                            horizontalScrolCard(
                              context,
                              'Recent Confirmed',
                              'Recent Recovered',
                              'Recent Deaths',
                              colorList2,
                              listItems[index].deltaconfirmed,
                              listItems[index].deltarecovered,
                              listItems[index].deltadeaths,
                            )
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
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: cf.Size.screenHeight / 6,
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

Widget countryCard(BuildContext context, colorList, strTitle, valData) {
  // TODO: implement build
  cf.Size.init(context);
  return Container(
      width: cf.Size.screenWidth / 3.4,
      child: Align(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Container(
                height: cf.Size.screenHeight/12.5,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0, top:5.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Expanded(
                          child:
                          Text(
                            strTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: cf.Size.blockSizeHorizontal*3.7,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w200),
                          )
                      )
                  ),
                )
            ),
            Container(
              width: cf.Size.screenWidth / 4,
              height: cf.Size.screenHeight / 15,
              child: Padding(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      valData,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: cf.Size.blockSizeHorizontal*3.9,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w200),
                    )
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle, color: colorList,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
            ),
          ])
      ));
}
