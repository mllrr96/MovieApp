import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

class AiringTodayScreen extends StatefulWidget {
  static const routeName = '/airing_today';

  @override
  _AiringTodayScreenState createState() => _AiringTodayScreenState();
}

class _AiringTodayScreenState extends State<AiringTodayScreen> {
  _loadTvAiring(BuildContext context) {
    context.read<TvAiringTodayBloc>().add(LoadTvAiringToday());
  }

  void _refresh() {
    _loadTvAiring(context);
  }

  @override
  void initState() {
    super.initState();
    _loadTvAiring(context);
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TvAiringTodayBloc, TvAiringTodayState>(
      listener: (context, state) {
        if (state is TvAiringTodayHasData) {
          _refreshController.refreshCompleted();
        } else if (state is TvAiringTodayError ||
            state is TvAiringTodayNoInternetConnection) {
          _refreshController.refreshFailed();
        }
      },
      builder: (context, state) {
        Widget _buildTvAiringToday() {
          if (state is TvAiringTodayHasData) {
            return ListView.builder(
              itemCount: state.result.results.length,
              itemBuilder: (BuildContext context, int index) {
                Movies movies = state.result.results[index];
                return CardMovies(
                  image: movies.posterPath ?? '',
                  title: movies.tvName ?? '',
                  vote: movies.voteAverage.toString(),
                  releaseDate: movies.tvRelease ?? '',
                  overview: movies.overview ?? '',
                  genre:
                      movies.genreIds?.take(3).map(buildGenreChip).toList() ??
                          [],
                  onTap: () {
                    Navigation.intentWithData(
                      context,
                      DetailScreen.routeName,
                      ScreenArguments(movies, false, false),
                    );
                  },
                );
              },
            );
          } else if (state is TvAiringTodayLoading) {
            return ShimmerList();
          } else if (state is TvAiringTodayError) {
            return CustomErrorWidget(message: state.errorMessage);
          } else if (state is TvAiringTodayNoData) {
            return CustomErrorWidget(message: state.message);
          } else if (state is TvAiringTodayNoInternetConnection) {
            return NoInternetWidget(
              message: AppConstant.noInternetConnection,
              onPressed: () => _loadTvAiring(context),
            );
          } else {
            return Center(child: Text(""));
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Airing Today'),
            centerTitle: true,
          ),
          body: SmartRefresher(
              onRefresh: _refresh,
              controller: _refreshController,
              child: _buildTvAiringToday()),
        );
      },
    );
  }
}
