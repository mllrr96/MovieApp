import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

class UpComingScreen extends StatefulWidget {
  static const routeName = '/up_coming';

  @override
  _UpComingScreenState createState() => _UpComingScreenState();
}

class _UpComingScreenState extends State<UpComingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Up Coming Movie'),
        centerTitle: true,
      ),
      body: SmartRefresher(
        onRefresh: () async {
          context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
        },
        controller: _refreshController,
        child: BlocConsumer<MovieUpComingBloc, MovieUpComingState>(
          listener: (context, state) {
            if (state is MovieUpComingHasData) {
              _refreshController.refreshCompleted();
            } else if (state is MovieUpComingError ||
                state is MovieUpComingNoInternetConnection) {
              _refreshController.refreshFailed();
            }
          },
          builder: (context, state) {
            if (state is MovieUpComingHasData) {
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
            } else if (state is MovieUpComingLoading) {
              return ShimmerList();
            } else if (state is MovieUpComingError) {
              return CustomErrorWidget(message: state.errorMessage);
            } else if (state is MovieUpComingNoData) {
              return CustomErrorWidget(message: state.message);
            } else if (state is MovieUpComingNoInternetConnection) {
              return NoInternetWidget(
                message: AppConstant.noInternetConnection,
                onPressed: () {
                  context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
                },
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
