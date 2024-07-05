import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:shared/shared.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

class TvOnTheAirBloc extends Bloc<TvOnTheAirEvent, TvOnTheAirState> {
  final Repository repository;

  TvOnTheAirBloc({required this.repository}) : super(InitialTvOnTheAir()) {
    on<LoadTvOnTheAir>(_loadTvOnTheAir);
  }

  _loadTvOnTheAir(
    LoadTvOnTheAir event,
    Emitter<TvOnTheAirState> emit,
  ) async {
    try {
      emit(TvOnTheAirLoading());
      var movies = await repository.getTvOnTheAir(
          ApiConstant.apiKey, ApiConstant.language);
      if (movies?.results.isEmpty ?? true) {
        emit(TvOnTheAirNoData(AppConstant.noData));
      } else {
        emit(TvOnTheAirHasData(movies!));
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        emit(TvOnTheAirNoInternetConnection());
      } else if (e.type == DioExceptionType.connectionError) {
        emit(TvOnTheAirNoInternetConnection());
      } else {
        emit(TvOnTheAirError(e.toString()));
      }
    }
  }
}
