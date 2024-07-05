import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

class CrewBloc extends Bloc<CrewEvent, CrewState> {
  final Repository repository;

  CrewBloc({required this.repository}) : super(InitialCrew()) {
    on<LoadCrew>(_loadCrew);
  }

  void _loadCrew(
    LoadCrew event,
    Emitter<CrewState> emit,
  ) async {
    if (event.isFromMovie) {
      try {
        emit(CrewLoading());
        var movies = await repository.getMovieCrew(
            event.movieId, ApiConstant.apiKey, ApiConstant.language);
        if (movies?.crew.isEmpty ?? true) {
          emit(CrewNoData(AppConstant.noCrew));
        } else {
          emit(CrewHasData(movies!));
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          emit(CrewNoInternetConnection());
        } else if (e.type == DioExceptionType.connectionError) {
          emit(CrewNoInternetConnection());
        } else {
          emit(CrewError(e.toString()));
        }
      }
    } else if (!event.isFromMovie) {
      try {
        emit(CrewLoading());
        var tvShow = await repository.getTvShowCrew(
            event.movieId, ApiConstant.apiKey, ApiConstant.language);
        if (tvShow?.crew.isEmpty ?? true) {
          emit(CrewNoData(AppConstant.noCrew));
        } else {
          emit(CrewHasData(tvShow!));
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          emit(CrewNoInternetConnection());
        } else if (e.type == DioExceptionType.connectionError) {
          emit(CrewNoInternetConnection());
        } else {
          emit(CrewError(e.toString()));
        }
      }
    }
  }
}
