import 'package:core/core.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPrefHelper prefHelper;

  ThemeBloc({required this.prefHelper})
      : super(ThemeState(isDarkTheme: false)) {
    on<ThemeChanged>(_onThemeChanged);
    on<GetTheme>(_onGetTheme);
  }

  void _onGetTheme(
    GetTheme event,
    Emitter<ThemeState> emit,
  ) async {
    final isDarkTheme = await prefHelper.getValueDarkTheme();
    emit(ThemeState(isDarkTheme: isDarkTheme));
  }

  void _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await prefHelper.saveValueDarkTheme(event.isDarkTheme);
    emit(ThemeState(isDarkTheme: event.isDarkTheme));
  }
}
