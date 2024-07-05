import 'package:core/core.dart';

class MovieRepository implements Repository {
  final ApiRepository apiRepository;
  // final LocalRepository localRepository;

  MovieRepository({required this.apiRepository});

  @override
  Future<Result?> getMovieNowPlaying(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getMovieNowPlaying(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result?> getMovieUpComing(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getMovieUpComing(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result?> getMoviePopular(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getMoviePopular(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result?> getTvAiringToday(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getTvAiringToday(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result?> getTvPopular(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getTvPopular(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Result?> getTvOnTheAir(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getTvOnTheAir(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ResultCrew?> getMovieCrew(
      [int movieId = 0,
      String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    final data = await apiRepository.getMovieCrew(movieId, apiKey, language);
    return data;
  }

  @override
  Future<ResultTrailer?> getMovieTrailer(int movieId,
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    final data = await apiRepository.getMovieTrailer(movieId, apiKey, language);
    return data;
  }

  @override
  Future<ResultCrew?> getTvShowCrew(
      [int tvId = 0,
      String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    final data = await apiRepository.getTvShowCrew(tvId, apiKey, language);
    return data;
  }

  @override
  Future<ResultTrailer?> getTvShowTrailer(int tvId,
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    final data = await apiRepository.getTvShowTrailer(tvId, apiKey, language);
    return data;
  }

  @override
  Future<Result?> getDiscoverMovie(
      [String apiKey = ApiConstant.apiKey,
      String language = ApiConstant.language]) async {
    try {
      final data = await apiRepository.getDiscoverMovie(apiKey, language);
      if (data == null) {
        return null;
      }
      return data;
    } catch (_) {
      return null;
    }
  }
}
