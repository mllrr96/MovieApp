import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:moviecatalogue/ui/movie/now_playing/now_playing_screen.dart';
import 'package:moviecatalogue/ui/movie/popular/movie_popular_screen.dart';
import 'package:moviecatalogue/ui/movie/up_coming/up_coming_screen.dart';
import 'package:shared/shared.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../setting/setting_screen.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen>
    with AutomaticKeepAliveClientMixin<MovieScreen> {
  int _current = 0;
  final RefreshController smartRefresherController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<MovieNowPlayingBloc>().add(LoadMovieNowPlaying());
    context.read<MoviePopularBloc>().add(LoadMoviePopular());
    context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Movies'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            padding: EdgeInsets.all(16.0),
            onPressed: () =>
                Navigation.intent(context, SettingScreen.routeName),
          ),
        ],
      ),
      body: SmartRefresher(
        onRefresh: () {
          context.read<MovieNowPlayingBloc>().add(LoadMovieNowPlaying());
          context.read<MoviePopularBloc>().add(LoadMoviePopular());
          context.read<MovieUpComingBloc>().add(LoadMovieUpComing());
        },
        controller: smartRefresherController,
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(), //kill bounce iOS
          child: Container(
            margin: EdgeInsets.all(Sizes.dp10(context)),
            child: Column(
              children: <Widget>[
                BlocConsumer<MovieNowPlayingBloc, MovieNowPlayingState>(
                  listener: (context, state) {
                    if (state is MovieNowPlayingHasData) {
                      smartRefresherController.refreshCompleted();
                    } else if (state is MovieNowPlayingError ||
                        state is MovieNowPlayingNoInternetConnection) {
                      smartRefresherController.refreshFailed();
                    }
                  },
                  builder: (context, state) {
                    if (state is MovieNowPlayingHasData) {
                      return BannerHome(
                        isFromMovie: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        },
                        data: state.result,
                        currentIndex: _current,
                        routeNameDetail: DetailScreen.routeName,
                        routeNameAll: NowPlayingScreen.routeName,
                      );
                    } else if (state is MovieNowPlayingLoading) {
                      return ShimmerBanner();
                    } else if (state is MovieNowPlayingError) {
                      return CustomErrorWidget(message: state.errorMessage);
                    } else if (state is MovieNowPlayingNoData) {
                      return CustomErrorWidget(message: state.message);
                    } else if (state is MovieNowPlayingNoInternetConnection) {
                      return NoInternetWidget(
                        message: AppConstant.noInternetConnection,
                        onPressed: () => context
                            .read<MovieNowPlayingBloc>()
                            .add(LoadMovieNowPlaying()),
                      );
                    } else {
                      return Center(child: Text(""));
                    }
                  },
                ),
                SizedBox(
                  height: Sizes.dp12(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Up Coming',
                            style: TextStyle(
                              fontSize: Sizes.dp14(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: Sizes.dp16(context),
                            ),
                            padding: EdgeInsets.all(16),
                            onPressed: () {
                              Navigation.intent(
                                  context, UpComingScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Sizes.width(context),
                      height: Sizes.width(context) / 1.8,
                      child:
                          BlocConsumer<MovieUpComingBloc, MovieUpComingState>(
                        listener: (context, state) {
                          if (state is MovieUpComingHasData) {
                            smartRefresherController.refreshCompleted();
                          } else if (state is MovieUpComingError ||
                              state is MovieUpComingNoInternetConnection) {
                            smartRefresherController.refreshFailed();
                          }
                        },
                        builder: (context, state) {
                          if (state is MovieUpComingHasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.result.results.length > 5
                                  ? 5
                                  : state.result.results.length,
                              itemBuilder: (BuildContext context, int index) {
                                Movies movies = state.result.results[index];
                                return CardHome(
                                  image: movies.posterPath ?? '',
                                  title: movies.title ?? '',
                                  rating: movies.voteAverage ?? 0.0,
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
                            return ShimmerCard();
                          } else if (state is MovieUpComingError) {
                            return CustomErrorWidget(
                                message: state.errorMessage);
                          } else if (state is MovieUpComingNoData) {
                            return CustomErrorWidget(message: state.message);
                          } else if (state
                              is MovieUpComingNoInternetConnection) {
                            return NoInternetWidget(
                              message: AppConstant.noInternetConnection,
                              onPressed: () => context
                                  .read<MovieUpComingBloc>()
                                  .add(LoadMovieUpComing()),
                            );
                          } else {
                            return Center(child: Text(""));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.dp12(context),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: Sizes.dp14(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: Sizes.dp16(context),
                            ),
                            padding: EdgeInsets.all(16),
                            onPressed: () {
                              Navigation.intent(
                                  context, MoviePopularScreen.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: Sizes.width(context),
                      height: Sizes.width(context) / 1.8,
                      child: BlocConsumer<MoviePopularBloc, MoviePopularState>(
                        listener: (context, state) {
                          if (state is MoviePopularHasData) {
                            smartRefresherController.refreshCompleted();
                          } else if (state is MoviePopularError ||
                              state is MoviePopularNoInternetConnection) {
                            smartRefresherController.refreshFailed();
                          }
                        },
                        builder: (context, state) {
                          if (state is MoviePopularHasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: state.result.results.length > 5
                                  ? 5
                                  : state.result.results.length,
                              itemBuilder: (BuildContext context, int index) {
                                Movies movies = state.result.results[index];
                                return CardHome(
                                  image: movies.posterPath ?? '',
                                  title: movies.title ?? '',
                                  rating: movies.voteAverage ?? 0.0,
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
                            return ShimmerCard();
                          } else if (state is MoviePopularError) {
                            return CustomErrorWidget(
                                message: state.errorMessage);
                          } else if (state is MoviePopularNoData) {
                            return CustomErrorWidget(message: state.message);
                          } else if (state
                              is MoviePopularNoInternetConnection) {
                            return NoInternetWidget(
                              message: AppConstant.noInternetConnection,
                              onPressed: () => context
                                  .read<MoviePopularBloc>()
                                  .add(LoadMoviePopular()),
                            );
                          } else {
                            return Center(child: Text(""));
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Sizes.dp12(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
