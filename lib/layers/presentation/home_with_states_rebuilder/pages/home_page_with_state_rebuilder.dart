import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../domain/entities/character.dart';
import '../model/home_view_model.dart';

class HomePageWithStatesRebuilder extends StatefulWidget {
  const HomePageWithStatesRebuilder({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageWithStatesRebuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RickAndMorty - StateRebuilder"),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: WhenRebuilder<HomeViewModel>(
            observe: () => RM.get<HomeViewModel>(),
            onIdle: () => _showLoadButton(),
            onWaiting: () => CircularProgressIndicator(),
            onError: (error) => Text('Future completes with error $error'),
            onData: (HomeViewModel data) => _showCharactersList(data.charList),
          ),
        ),
      ),
    );
  }

  Widget _showLoadButton() {
    final model = RM.get<HomeViewModel>();
    return MaterialButton(
      onPressed: () => model.setState((vm) => vm.loadAllCharacters()),
      child: Text("Load data"),
      color: Colors.blue,
    );
  }

  Widget _showCharactersList(List<Character> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final character = list[index];
        return ListTile(
          leading: Image.network(
            character.image,
            errorBuilder: (context, error, stackTrace) => Text('😢\noffline'),
          ),
          title: Text('${character.name}'),
          subtitle: Text('${character.status}'),
        );
      },
    );
  }
}
