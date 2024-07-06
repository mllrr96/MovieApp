import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

class NowPlayingScreen extends StatefulWidget {
  static const routeName = '/now_playing';

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final RefreshController _refreshController = RefreshController();
  _loadMovieNowPlaying(BuildContext context) {
    context.read<MovieNowPlayingBloc>().add(LoadMovieNowPlaying());
  }

  void _refresh() {
    _loadMovieNowPlaying(context);
  }

  @override
  void initState() {
    super.initState();
    _loadMovieNowPlaying(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieNowPlayingBloc, MovieNowPlayingState>(
      listener: (context, state) {
        if (state is MovieNowPlayingHasData) {
          _refreshController.refreshCompleted();
        } else if (state is MovieNowPlayingError ||
            state is MovieNowPlayingNoInternetConnection) {
          _refreshController.refreshFailed();
        }
      },
      builder: (context, state) {
        Widget _buildNowPlaying() {
          if (state is MovieNowPlayingHasData) {
            return ListView.builder(
              itemCount: state.result.results.length,
              itemBuilder: (BuildContext context, int index) {
                Movies movies = state.result.results[index];
                return CardMovies(
                  image: movies.posterPath ?? '',
                  title: movies.title ?? '',
                  vote: movies.voteAverage.toString(),
                  releaseDate: movies.releaseDate ?? '',
                  overview: movies.overview ?? '',
                  genre:
                      movies.genreIds?.take(3).map(buildGenreChip).toList() ??
                          [],
                  onTap: () {
                    Navigation.intentWithData(
                      context,
                      DetailScreen.routeName,
                      ScreenArguments(movies, true, false),
                    );
                  },
                );
              },
            );
          } else if (state is MovieNowPlayingLoading) {
            return ShimmerList();
          } else if (state is MovieNowPlayingError) {
            return CustomErrorWidget(message: state.errorMessage);
          } else if (state is MovieNowPlayingNoData) {
            return CustomErrorWidget(message: state.message);
          } else if (state is MovieNowPlayingNoInternetConnection) {
            return NoInternetWidget(
              message: AppConstant.noInternetConnection,
              onPressed: () => _loadMovieNowPlaying(context),
            );
          } else {
            return Center(child: Text(""));
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Now Playing Movies'),
            centerTitle: true,
          ),
          body: SmartRefresher(
              onRefresh: _refresh,
              controller: _refreshController,
              child: _buildNowPlaying()),
        );
      },
    );
  }
}
