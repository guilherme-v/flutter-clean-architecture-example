import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import '../bloc/home_bloc.dart';

class HomePageWithBloc extends StatefulWidget {
  const HomePageWithBloc({Key key}) : super(key: key);

  @override
  _HomePageWithBlocState createState() => _HomePageWithBlocState();
}

class _HomePageWithBlocState extends State<HomePageWithBloc> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (BuildContext context) => di.sl<HomeCubit>(),
        ),
      ],
      // provider a context with HomeCubit down the tree
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("RickAndMorty - Bloc"),
            ),
            body: Center(
              child: Container(
                color: Colors.white,
                child: BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is Initial) {
                      return _showLoadButton(context);
                    } else if (state is Loading) {
                      return CircularProgressIndicator();
                    } else if (state is Error) {
                      return Container();
                    } else if (state is Success) {
                      return _showCharactersList(state);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _showLoadButton(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        _loadData(context);
      },
      child: Text("Load data"),
      color: Colors.blue,
    );
  }

  Widget _showCharactersList(Success state) {
    return ListView.builder(
      itemCount: state.characterList.length,
      itemBuilder: (context, index) {
        final character = state.characterList[index];
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

  void _loadData(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    cubit.showLoadingAndFetchCharacters();
  }
}
