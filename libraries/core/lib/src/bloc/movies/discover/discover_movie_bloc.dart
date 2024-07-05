import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class DiscoverMovieBloc extends Bloc<DiscoverMovieEvent, DiscoverMovieState> {
  final Repository repository;

  DiscoverMovieBloc({required this.repository})
      : super(InitialDiscoverMovie()) {
    on<LoadDiscoverMovie>(_loadDiscoverMovie);
  }

  void _loadDiscoverMovie(
    LoadDiscoverMovie event,
    Emitter<DiscoverMovieState> emit,
  ) async {
    try {
      emit(DiscoverMovieLoading());
      var movies = await repository.getDiscoverMovie(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(DiscoverMovieNoData(AppConstant.noData));
      } else {
        emit(DiscoverMovieHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(DiscoverMovieNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(DiscoverMovieNoInternetConnection());
      } else {
        emit(DiscoverMovieError(e.toString()));
      }
    }
  }
}
