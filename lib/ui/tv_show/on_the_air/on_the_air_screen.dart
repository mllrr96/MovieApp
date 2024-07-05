import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

class OnTheAirScreen extends StatefulWidget {
  static const routeName = '/on_the_air';

  @override
  _OnTheAirScreenState createState() => _OnTheAirScreenState();
}

class _OnTheAirScreenState extends State<OnTheAirScreen> {
  _loadTvOnAir(BuildContext context) {
    context.read<TvOnTheAirBloc>().add(LoadTvOnTheAir());
  }

  void _refresh() {
    _loadTvOnAir(context);
  }

  @override
  void initState() {
    super.initState();
    _loadTvOnAir(context);
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('On The Air'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        onRefresh: _refresh,
        controller: _refreshController,
        child: BlocConsumer<TvOnTheAirBloc, TvOnTheAirState>(
          listener: (context, state) {
            if (state is TvOnTheAirHasData) {
              _refreshController.refreshCompleted();
            } else if (state is TvOnTheAirError ||
                state is TvOnTheAirNoInternetConnection) {
              _refreshController.refreshFailed();
            }
          },
          builder: (context, state) {
            if (state is TvOnTheAirHasData) {
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
            } else if (state is TvOnTheAirLoading) {
              return ShimmerList();
            } else if (state is TvOnTheAirError) {
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is TvOnTheAirNoData) {
              return CustomErrorWidget(message: state.message);
            } else if (state is TvOnTheAirNoInternetConnection) {
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () => _loadTvOnAir(context),
              );
            } else {
              return Center(child: Text(""));
            }
          },
        ),
      ),
    );
  }
}
