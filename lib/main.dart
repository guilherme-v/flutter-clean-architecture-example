import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'injection_container.dart' as di;
import 'layers/presentation/home_with_bloc/bloc/home_bloc.dart';
import 'layers/presentation/home_with_bloc/pages/home_page_with_bloc.dart';
import 'layers/presentation/home_with_provider/notifiers/home_notifier.dart';
import 'layers/presentation/home_with_provider/pages/home_page_with_provider.dart';
import 'layers/presentation/home_with_states_rebuilder/model/home_view_model.dart';
import 'layers/presentation/home_with_states_rebuilder/pages/home_page_with_state_rebuilder.dart';

void main() async {
  // Initialize the injection container
  await di.init();

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // * USED by the plain Provider version
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeNotifier>(
            create: (_) => di.sl<HomeNotifier>()),
      ],
      // * USED by BLOC version
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (BuildContext context) => di.sl<HomeCubit>(),
          ),
        ],
        // * USED by States Rebuilder version
        child: Injector(
          inject: [
            Inject<HomeViewModel>(() => di.sl<HomeViewModel>()),
          ],
          builder: (_) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomePageWithBloc(), // BLOC version
            // home: HomePageWithProvider(), // plain provider Version
            // home: HomePageWithStatesRebuilder(), // StateRebuilder Version
          ),
        ),
      ),
    );
  }
}
