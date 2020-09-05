import 'package:clean_arch_flutter/layers/presentation/home_with_bloc/pages/home_page_with_bloc.dart';
import 'package:clean_arch_flutter/layers/presentation/home_with_provider/pages/home_page_with_provider.dart';
import 'package:clean_arch_flutter/layers/presentation/home_with_states_rebuilder/pages/home_page_with_state_rebuilder.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _appPages = <Widget>[
    HomePageWithBloc(),
    HomePageWithProvider(),
    HomePageWithStatesRebuilder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // use an IndexedStack to keep the state of all pages
      // and to avoid rebuild them
      body: IndexedStack(
        index: _selectedIndex,
        children: _appPages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Bloc',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Provider',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'StatesRebulder',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
