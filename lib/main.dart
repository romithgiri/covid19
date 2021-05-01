import 'package:flutter/material.dart';
import './home.dart';
import './countryList.dart';
import './india.dart';
import 'timeLineView.dart';
import 'contactUs.dart';
import 'package:splashscreen/splashscreen.dart';
import 'ConfigFile.dart' as cf;
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'COVID-19';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    CountryList(),
    OwnCountryList(),
    TimeLineList(),
//    ContactUs()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    cf.Size.init(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Container(
      height: cf.Size.screenHeight,
        child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('COVID-19 Dashboard',style: TextStyle(color: Colors.pink, fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                backgroundColor: Colors.white,
                elevation: 10.0,
              ),
              backgroundColor: Colors.white,
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    title: Text('Dashboard'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.assistant_photo),
                    title: Text('Countries'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    title: Text('India'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.timeline),
                    title: Text('Time Line for India'),
                  ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.email),
//              title: Text('Contact Us'),
//            ),
                ],
                currentIndex: _selectedIndex,
                showUnselectedLabels: true,
                selectedItemColor: Colors.pinkAccent[700],
                unselectedItemColor: Colors.black,
                onTap: _onItemTapped,
              ),
            )
        )
    );
  }

}

