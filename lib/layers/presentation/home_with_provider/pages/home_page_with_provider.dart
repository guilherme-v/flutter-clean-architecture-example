import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/character.dart';
import '../notifiers/home_notifier.dart';

class HomePageWithProvider extends StatefulWidget {
  const HomePageWithProvider({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageWithProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RickAndMorty"),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: _showBody(),
        ),
      ),
    );
  }

  Widget _showBody() {
    final isLoading = context.select((HomeNotifier n) => n.homeModel.isLoading);
    final error = context.select((HomeNotifier n) => n.homeModel.error);
    final list = context.select((HomeNotifier n) => n.homeModel.charactersList);

    if (!isLoading && list == null) {
      return _showLoadButton();
    } else if (isLoading) {
      return CircularProgressIndicator();
    } else if (!isLoading && list != null) {
      return _showCharactersList(list);
    } else if (error != null) {
      return Container();
    } else {
      return Container();
    }
  }

  Widget _showLoadButton() {
    return MaterialButton(
      onPressed: () => context.read<HomeNotifier>().loadAllCharacters(),
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
