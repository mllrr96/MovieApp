import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeModeState extends Equatable {
  final ThemeMode themeMode;

  ThemeModeState(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}
