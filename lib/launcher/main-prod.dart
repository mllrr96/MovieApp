import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'app_config.dart';
import 'movie_app.dart';

void main() async {
  Bloc.observer = MovieBlocObserver();
  Config.appFlavor = Flavor.RELEASE;
  WidgetsFlutterBinding.ensureInitialized();
  await Di.init(ApiConstant.baseUrlProd);
  runApp(MyApp());
}
