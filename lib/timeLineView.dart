import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'ConfigFile.dart' as cf;


class TimeLineListDataCls {
  final String dailyconfirmed;
  final String dailydeceased;
  final String dailyrecovered;
  final String date;
  final String totalconfirmed;
  final String totaldeceased;
  final String totalrecovered;

  TimeLineListDataCls({
    this.dailyconfirmed,
    this.dailydeceased,
    this.dailyrecovered,
    this.date,
    this.totalconfirmed,
    this.totaldeceased,
    this.totalrecovered,
  });

  factory TimeLineListDataCls.fromJson(Map<String, dynamic> json) {
    return new TimeLineListDataCls(
      dailyconfirmed: json['dailyconfirmed'].toString(),
      dailydeceased: json['dailydeceased'].toString(),
      dailyrecovered: json['dailyrecovered'].toString(),
      date: json['date'].toString(),
      totalconfirmed: json['totalconfirmed'].toString(),
      totaldeceased: json['totaldeceased'].toString(),
      totalrecovered: json['totalrecovered'].toString(),
    );
  }
}

class TimeLineList extends StatefulWidget {
  @override
  TimeLineListPageState createState() => TimeLineListPageState();
}

class TimeLineListPageState extends State<TimeLineList> {
  bool toggle = false;
  var data = [];
  var dataCount;
  List<TimeLineListDataCls> dataFromServer = List();
  List<TimeLineListDataCls> filterData = List();

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

  Future<List<TimeLineListDataCls>> asyncOperation() async {
    http.Response response = await http.get('https://api.covid19india.org/data.json');
    var responseJson = json.decode(response.body);
    setState(() {
      dataFromServer = (responseJson['cases_time_series'] as List).map((p) => TimeLineListDataCls.fromJson(p)).toList();
      filterData = dataFromServer.reversed.toList();
    });
    await toggleLoader();
    return dataFromServer = (responseJson['cases_time_series'] as List).map((p) => TimeLineListDataCls.fromJson(p)).toList();
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
                                  .where((u) => (u.date
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
            ])
        )
    );
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
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      'Last updated date : ',
                                      style: TextStyle(
                                          color: Colors.pinkAccent[700],
                                          fontSize: cf.Size.blockSizeHorizontal*4.5,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      listItems[index].date,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: cf.Size.blockSizeHorizontal*4.5,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Column(
                                  children: <Widget>[
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.red, 'Daily Confirmed : ', listItems[index].dailyconfirmed),
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.green, 'Daily Recovered : ', listItems[index].dailyrecovered),
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.indigo, 'Daily Deaths : ', listItems[index].dailydeceased),
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.pink, 'Total Confirmed : ', listItems[index].totalconfirmed),
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.blue, 'Total Recovered : ', listItems[index].totalrecovered),
                                    TimeLineParentView(context,Icons.arrow_drop_down_circle, Colors.lightGreen, 'Total Deaths : ', listItems[index].totaldeceased),
                                  ],
                                )
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

Widget TimeLineParentView (BuildContext context, strIcon, strColor, strTitle, strVal) {
  cf.Size.init(context);
  return Container(
      child: Row(
        children: <Widget>[
          Icon(
            strIcon,
            color: strColor,
          ),
          Container(
              width: cf.Size.screenWidth/2.8,
              child: InfoViewTimeLine(context,strTitle)
          ),
          InfoViewTimeLine(context, strVal),
        ],
      )
  );
}

Widget InfoViewTimeLine(BuildContext context, strData) {
  cf.Size.init(context);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 2.0),
    child: Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        strData,
        style: TextStyle(
            color: Colors.black,
            fontSize: cf.Size.blockSizeHorizontal*3.6,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
      ),
    ),
  );
}
