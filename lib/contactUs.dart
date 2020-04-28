import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'ConfigFile.dart' as cf;

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool toggle = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
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
                          elevation: 15,
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Develop By',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.pinkAccent[700], fontSize: cf.Size.blockSizeHorizontal*5, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
                              ),
                              Container(
                                width: cf.Size.screenWidth,
                                height: cf.Size.screenHeight/3,
                                child: Image.asset('images/logo.png'),
                              ),
                              OutlineButton(
                                shape: StadiumBorder(),
                                textColor: Colors.blue,
                                child: Text('Button Text'),
                                borderSide: BorderSide(
                                    color: Colors.blue, style: BorderStyle.solid,
                                    width: 1),
                                onPressed: () {},
                              )
                            ]
                          )
                      )
                  )
                ])
            )
        )
    );
  }
}