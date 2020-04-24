import 'package:flutter/material.dart';
import './home.dart';
import './countryList.dart';
import './map.dart';


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
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    CountryList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COVID-19',style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        backgroundColor: Colors.pinkAccent[400],
      ),
      backgroundColor: Colors.black54,
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
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assistant_photo),
            title: Text('Countries'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent[700],
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}