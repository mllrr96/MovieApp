import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  final Repository repository;

  TrailerBloc({required this.repository}) : super(InitialTrailer()) {
    on<LoadTrailer>(_LoadTrailer);
  }

  void _LoadTrailer(
    LoadTrailer event,
    Emitter<TrailerState> emit,
  ) async {
    if (event.isFromMovie) {
      try {
        emit(TrailerLoading());
        var movies = await repository.getMovieTrailer(
            event.movieId, ApiConstant.apiKey, ApiConstant.language);
        if (movies?.trailer.isEmpty ?? true) {
          emit(TrailerNoData(AppConstant.noTrailer));
        } else {
          emit(TrailerHasData(movies!));
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          emit(TrailerNoInternetConnection());
        } else if (e.type == DioExceptionType.connectionError) {
          emit(TrailerNoInternetConnection());
        } else {
          emit(TrailerError(e.toString()));
        }
      }
    } else if (!event.isFromMovie) {
      try {
        emit(TrailerLoading());
        var tvShow = await repository.getTvShowTrailer(
            event.movieId, ApiConstant.apiKey, ApiConstant.language);
        if (tvShow?.trailer.isEmpty ?? true) {
          emit(TrailerNoData(AppConstant.noTrailer));
        } else {
          emit(TrailerHasData(tvShow!));
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.receiveTimeout) {
          emit(TrailerNoInternetConnection());
        } else if (e.type == DioExceptionType.connectionError) {
          emit(TrailerNoInternetConnection());
        } else {
          emit(TrailerError(e.toString()));
        }
      }
    }
  }
}
