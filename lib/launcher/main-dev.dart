import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'app_config.dart';
import 'movie_app.dart';

void main() async {
  Bloc.observer = MovieBlocObserver();
  Config.appFlavor = Flavor.DEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();
  await Di.init(ApiConstant.baseUrlDebug);
  runApp(MyApp());
}
