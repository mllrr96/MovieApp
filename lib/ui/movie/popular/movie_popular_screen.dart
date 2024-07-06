import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:shared/shared.dart';

class MoviePopularScreen extends StatefulWidget {
  static const routeName = '/movie_popular';

  @override
  _MoviePopularScreenState createState() => _MoviePopularScreenState();
}

class _MoviePopularScreenState extends State<MoviePopularScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MoviePopularBloc>().add(LoadMoviePopular());
  }

  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoviePopularBloc, MoviePopularState>(
      listener: (context, state) {
        if (state is MoviePopularHasData) {
          _refreshController.refreshCompleted();
        } else if (state is MoviePopularError ||
            state is MoviePopularNoInternetConnection) {
          _refreshController.refreshFailed();
        }
      },
      builder: (context, state) {
        Widget _buildMoviePopular() {
          if (state is MoviePopularHasData) {
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
          } else if (state is MoviePopularLoading) {
            return ShimmerList();
          } else if (state is MoviePopularError) {
            return CustomErrorWidget(message: state.errorMessage);
          } else if (state is MoviePopularNoData) {
            return CustomErrorWidget(message: state.message);
          } else if (state is MoviePopularNoInternetConnection) {
            return NoInternetWidget(
              message: AppConstant.noInternetConnection,
              onPressed: () =>
                  context.read<MoviePopularBloc>().add(LoadMoviePopular()),
            );
          } else {
            return Center(child: Text(""));
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Popular Movies'),
            centerTitle: true,
          ),
          body: SmartRefresher(
              onRefresh: () async {
                context.read<MoviePopularBloc>().add(LoadMoviePopular());
              },
              controller: _refreshController,
              child: _buildMoviePopular()),
        );
      },
    );
  }
}
