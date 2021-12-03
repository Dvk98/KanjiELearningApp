import 'package:app/models/vocab.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:app/game/kanji_learning_game.dart';
import 'package:app/screens/dashboard.dart';
import 'package:flutter/services.dart';

import 'home.dart';
import 'settings.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late List<Vocab> vocabs = [];
  int currentIndex = 0;
  late List<Widget> _widgetOptions;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List listOfColors = [
    Container(
      color: Colors.blueAccent,
    ),
    Container(
      color: Colors.redAccent,
    ),
    Container(
      color: Colors.orangeAccent,
    ),
    Container(
      color: Colors.cyanAccent,
    )
  ];

  void _loadData() async {
    final _rawData =
        await rootBundle.loadString("assets/vocabulary/Wordlist_N5_suf;.csv");
    List<List<dynamic>> _listData = CsvToListConverter()
        .convert(_rawData, fieldDelimiter: "#", textDelimiter: "'");
    for (var item in _listData) {
      if (item[0] == "Kanji") {
        continue;
      }
      item[0] = item[0].substring(1, item[0].length - 1);
      item[1] = item[1].substring(1, item[1].length - 1);
      item[1] = item[1].split(",");
      for (int i = 0; i < item[1].length; i++) {
        if (i == item[1].length - 1 && i != 0) {
          item[1][i] = item[1][i].substring(2, item[1][i].length - 1);
        } else {
          item[1][i] = item[1][i].substring(1, item[1][i].length - 1);
        }
      }
      item[2] = item[2];
      item[3] = item[3].substring(1, item[3].length - 1);
      item[3] = item[3].split(",");
      item[4] = item[4].substring(1, item[4].length - 1);
      item[4] = item[4].split(",");

      Vocab vocab = Vocab(item);
      vocabs.add(vocab);
    }
  }

  @override
  void initState() {
    _loadData();
    _widgetOptions = <Widget>[
      Home(key: ValueKey("Home")),
      Dashboard(key: ValueKey("Dashboard")),
      gameWidgetBuilder(context, vocabs),
      Settings(key: ValueKey("Settings")),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'KanjiLearningGame',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        backgroundColor: Colors.black45,
      ),
      body: Center(
        child: _widgetOptions.elementAt(currentIndex),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.videogame_asset),
            title: Text('Game'),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.blueAccent,
            inactiveColor: Colors.lightGreenAccent,
          ),
        ],
      ),
    );
  }
}
