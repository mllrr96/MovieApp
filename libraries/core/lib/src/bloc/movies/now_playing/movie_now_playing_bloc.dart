import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class MovieNowPlayingBloc
    extends Bloc<MovieNowPlayingEvent, MovieNowPlayingState> {
  final Repository repository;

  MovieNowPlayingBloc({required this.repository})
      : super(InitialMovieNowPlaying()) {
    on<LoadMovieNowPlaying>(_loadMovieNowPlaying);
  }

  void _loadMovieNowPlaying(
    LoadMovieNowPlaying event,
    Emitter<MovieNowPlayingState> emit,
  ) async {
    try {
      emit(MovieNowPlayingLoading());
      var movies = await repository.getMovieNowPlaying(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(MovieNowPlayingNoData(AppConstant.noData));
      } else {
        emit(MovieNowPlayingHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(MovieNowPlayingNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(MovieNowPlayingNoInternetConnection());
      } else {
        emit(MovieNowPlayingError(e.toString()));
      }
    }
  }
}
