import 'package:core/core.dart';
import 'package:flutter/material.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeModeState> {
  final SharedPrefHelper prefHelper;

  ThemeBloc({required this.prefHelper})
      : super(ThemeModeState(ThemeMode.system)) {
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<GetThemeMode>(_onGetThemeMode);
  }

  void _onGetThemeMode(
    GetThemeMode event,
    Emitter<ThemeModeState> emit,
  ) async =>
      emit(ThemeModeState(await prefHelper.getThemeMode()));

  void _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<ThemeModeState> emit,
  ) async {
    await prefHelper.saveThemeMode(event.themeMode);
    emit(ThemeModeState(event.themeMode));
  }
}
