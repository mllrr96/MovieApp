import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class MovieUpComingBloc extends Bloc<MovieUpComingEvent, MovieUpComingState> {
  final Repository repository;

  MovieUpComingBloc({required this.repository})
      : super(InitialMovieUpComing()) {
    on<LoadMovieUpComing>(_loadMovieUpComing);
  }

  void _loadMovieUpComing(
    LoadMovieUpComing event,
    Emitter<MovieUpComingState> emit,
  ) async {
    try {
      emit(MovieUpComingLoading());
      var movies = await repository.getMovieUpComing(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(MovieUpComingNoData(AppConstant.noData));
      } else {
        emit(MovieUpComingHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MovieUpComingNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(MovieUpComingNoInternetConnection());
      } else {
        emit(MovieUpComingError(e.toString()));
      }
    }
  }
}
