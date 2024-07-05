import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class TvAiringTodayBloc extends Bloc<TvAiringTodayEvent, TvAiringTodayState> {
  final Repository repository;

  TvAiringTodayBloc({required this.repository})
      : super(InitialTvAiringToday()) {
    on<LoadTvAiringToday>(_loadTvAiringToday);
  }

  void _loadTvAiringToday(
    LoadTvAiringToday event,
    Emitter<TvAiringTodayState> emit,
  ) async {
    try {
      emit(TvAiringTodayLoading());
      var movies = await repository.getTvAiringToday(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(TvAiringTodayNoData(AppConstant.noData));
      } else {
        emit(TvAiringTodayHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvAiringTodayNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(TvAiringTodayNoInternetConnection());
      } else {
        emit(TvAiringTodayError(e.toString()));
      }
    }
  }
}
