import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../../injection_container.dart';
import '../../../domain/entities/character.dart';
import '../controller/home_controller.dart';
import '../view_data/view_data.dart';

class HomePageWithValueNotifier extends StatefulWidget {
  const HomePageWithValueNotifier({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageWithValueNotifier> {
  final controller = sl.get<HomeController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RickAndMorty - ValueNotifier"),
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
    return Stack(
      children: [
        ValueListenableBuilder(
          valueListenable: controller.listNotifier,
          child: Container(),
          builder: (BuildContext context, ViewData<List<Character>> viewData,
              Widget child) {
            final isLoading = viewData.isLoading;
            final list = viewData.data;
            final error = viewData.error;

            if (!isLoading && list == null) {
              return _showLoadButton();
            } else if (isLoading) {
              return CircularProgressIndicator();
            } else if (!isLoading && list != null) {
              return _showCharactersList(list);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget _showLoadButton() {
    return MaterialButton(
      onPressed: () => controller.loadAllCharacters(),
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
