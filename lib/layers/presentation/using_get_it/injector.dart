import 'package:get_it/get_it.dart';
import 'package:rickmorty/layers/data/character_repository_impl.dart';
import 'package:rickmorty/layers/data/source/local/local_storage.dart';
import 'package:rickmorty/layers/data/source/network/api.dart';
import 'package:rickmorty/layers/domain/repository/character_repository.dart';
import 'package:rickmorty/layers/domain/usecase/get_all_characters.dart';
import 'package:rickmorty/layers/presentation/using_get_it/details_page/controller/character_details_controller.dart';
import 'package:rickmorty/layers/presentation/using_get_it/list_page/controller/character_page_controller.dart';
import 'package:rickmorty/main.dart';

GetIt getIt = GetIt.instance;

Future<void> initializeGetIt() async {
  // ---------------------------------------------------------------------------
  // DATA Layer
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<Api>(() => ApiImpl());
  getIt.registerFactory<LocalStorage>(
    () => LocalStorageImpl(
      sharedPreferences: sharedPref,
    ),
  );

  getIt.registerFactory<CharacterRepository>(
    () => CharacterRepositoryImpl(
      api: getIt(),
      localStorage: getIt(),
    ),
  );

  // ---------------------------------------------------------------------------
  // DOMAIN Layer
  // ---------------------------------------------------------------------------
  getIt.registerFactory(
    () => GetAllCharacters(
      repository: getIt(),
    ),
  );

  // ---------------------------------------------------------------------------
  // PRESENTATION Layer
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton(
    () => CharacterPageController(getAllCharacters: getIt()),
  );
  getIt.registerLazySingleton(
    () => CharacterDetailsController(),
  );
}
