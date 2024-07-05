import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final Repository repository;

  TvPopularBloc({required this.repository}) : super(InitialTvPopular()) {
    on<LoadTvPopular>(_loadTvPopular);
  }

  void _loadTvPopular(
    LoadTvPopular event,
    Emitter<TvPopularState> emit,
  ) async {
    try {
      emit(TvPopularLoading());
      var movies = await repository.getTvPopular(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(TvPopularNoData(AppConstant.noData));
      } else {
        emit(TvPopularHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvPopularNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(TvPopularNoInternetConnection());
      } else {
        emit(TvPopularError(e.toString()));
      }
    }
  }
}
