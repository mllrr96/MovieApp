import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class MoviePopularBloc extends Bloc<MoviePopularEvent, MoviePopularState> {
  final Repository repository;

  MoviePopularBloc({required this.repository}) : super(InitialMoviePopular()) {
    on<LoadMoviePopular>(_loadMoviePopular);
  }

  void _loadMoviePopular(
    LoadMoviePopular event,
    Emitter<MoviePopularState> emit,
  ) async {
    try {
      emit(MoviePopularLoading());
      var movies = await repository.getMoviePopular(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(MoviePopularNoData(AppConstant.noData));
      } else {
        emit(MoviePopularHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MoviePopularNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(MoviePopularNoInternetConnection());
      } else {
        emit(MoviePopularError(e.toString()));
      }
    }
  }
}
