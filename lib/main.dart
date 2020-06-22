import 'package:clean_arch_flutter/layers/presentation/home_with_provider/notifiers/home_notifier.dart';
import 'package:clean_arch_flutter/layers/presentation/home_with_provider/pages/home_page_with_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'injection_container.dart' as di;
import 'layers/presentation/home_with_bloc/bloc/home_bloc.dart';
import 'layers/presentation/home_with_bloc/pages/home_page.dart';

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
          BlocProvider<HomeBloc>(
            create: (BuildContext context) => di.sl<HomeBloc>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: HomePage(), // BLOC version
          home: HomePageWithProvider(), // plain provider Version
        ),
      ),
    );
  }
}
