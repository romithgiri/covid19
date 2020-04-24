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

class _CountryListPageState extends State<CountryList> {
  TextEditingController _textController = TextEditingController();

  bool toggle = false;
  var data;
  var dataCount;

  @override
  void initState() {
    super.initState();
    asyncOperation().then((val) {}).catchError((error, stackTrace) {
      print("C33333333333333: $error");
    });
  }

  Future<void> asyncOperation() async {
    var url = 'https://api.covid19api.com/summary';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        data = jsonResponse['Countries'];
        dataCount = data.length;
      });
      await toggleLoader();
      return 0;
    } else {
      print('Error : ${response.statusCode}.');
      return 0;
    }
  }

  void filterSearchResults(String query) {
    print('Test ------------------------------- 111');
  } //Now using

  onItemChanged(String value) {
    print('######################################################################');
    var oldData = data;
    var n = data.length;
    print('1 ------: $oldData');
    print('2 ------: $n');
    data = null;
    print('3 ------: $data');
    setState(() {
      for (var i = 0; i < n; i++) {
        print('Inside for loop :- $i');
        print('********* :- $value');
        print('__________________________________________________');
        if (oldData[i]['Country'].where((string) =>
            string.toLowerCase().contains(value.toLowerCase())).toList()) {
          data.add(oldData[i]);
        }
      }
    });
    print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
  }

  Widget getListView() {
//    var listItems = getListElements();
    var listItems = data;
    var listview = ListView.builder(
        itemCount: data.length,
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
                        listItems[index]['Country'],
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
                      filterSearchResults(value);
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
