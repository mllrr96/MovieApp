import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/detail/detail_screen.dart';
import 'package:moviecatalogue/ui/tv_show/airing_today/airing_today_screen.dart';
import 'package:moviecatalogue/ui/tv_show/on_the_air/on_the_air_screen.dart';
import 'package:moviecatalogue/ui/tv_show/popular/tv_popular_screen.dart';
import 'package:shared/shared.dart';

import '../setting/setting_screen.dart';

class TvShowScreen extends StatefulWidget {
  @override
  _TvShowScreenState createState() => _TvShowScreenState();
}

class _TvShowScreenState extends State<TvShowScreen>
    with AutomaticKeepAliveClientMixin<TvShowScreen> {
  int _current = 0;
  final smartRefresherController = RefreshController();

  _loadTvOnAir(BuildContext context) {
    context.read<TvOnTheAirBloc>().add(LoadTvOnTheAir());
  }

  _loadTvAiring(BuildContext context) {
    context.read<TvAiringTodayBloc>().add(LoadTvAiringToday());
  }

  _loadTvPopular(BuildContext context) {
    context.read<TvPopularBloc>().add(LoadTvPopular());
  }

  void _refresh() {
    _loadTvOnAir(context);
    _loadTvAiring(context);
    _loadTvPopular(context);
  }

  @override
  void initState() {
    super.initState();
    _loadTvOnAir(context);
    _loadTvAiring(context);
    _loadTvPopular(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tv Show'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigation.intent(context, SettingScreen.routeName),
          ),
        ],
      ),
      body: SmartRefresher(
        onRefresh: _refresh,
        controller: smartRefresherController,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(), //kill bounce iOS
      child: Container(
        margin: EdgeInsets.all(Sizes.dp10(context)),
        child: Column(
          children: <Widget>[
            _buildBanner(context),
            SizedBox(
              height: Sizes.dp12(context),
            ),
            _buildAiringToday(context),
            SizedBox(
              height: Sizes.dp12(context),
            ),
            _buildPopular(context),
            SizedBox(
              height: Sizes.dp12(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return BlocConsumer<TvOnTheAirBloc, TvOnTheAirState>(
      listener: (context, state) {
        if (state is TvOnTheAirHasData) {
          smartRefresherController.refreshCompleted();
        } else if (state is TvOnTheAirError ||
            state is TvOnTheAirNoInternetConnection) {
          smartRefresherController.refreshCompleted();
        }
      },
      builder: (context, state) {
        if (state is TvOnTheAirHasData) {
          return BannerHome(
            isFromMovie: false,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            data: state.result,
            currentIndex: _current,
            routeNameDetail: DetailScreen.routeName,
            routeNameAll: OnTheAirScreen.routeName,
          );
        } else if (state is TvOnTheAirLoading) {
          return ShimmerBanner();
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
    );
  }

  Widget _buildAiringToday(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Text(
                'Airing Today',
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
                onPressed: () {
                  Navigation.intent(context, AiringTodayScreen.routeName);
                },
              ),
            ],
          ),
        ),
        Container(
          width: Sizes.width(context),
          height: Sizes.width(context) / 1.8,
          child: BlocConsumer<TvAiringTodayBloc, TvAiringTodayState>(
            listener: (context, state) {
              if (state is TvAiringTodayHasData) {
                smartRefresherController.refreshCompleted();
              } else if (state is TvAiringTodayError ||
                  state is TvAiringTodayNoInternetConnection) {
                smartRefresherController.refreshFailed();
              }
            },
            builder: (context, state) {
              if (state is TvAiringTodayHasData) {
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
                      title: movies.tvName ?? '',
                      rating: movies.voteAverage ?? 0.0,
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
                return ShimmerCard();
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
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopular(BuildContext context) {
    return Column(
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
                onPressed: () {
                  Navigation.intent(context, TvPopularScreen.routeName);
                },
              ),
            ],
          ),
        ),
        Container(
          width: Sizes.width(context),
          height: Sizes.width(context) / 1.8,
          child: BlocConsumer<TvPopularBloc, TvPopularState>(
            listener: (context, state) {
              if (state is TvPopularHasData) {
                smartRefresherController.refreshCompleted();
              } else if (state is TvPopularError ||
                  state is TvPopularNoInternetConnection) {
                smartRefresherController.refreshFailed();
              }
            },
            builder: (context, state) {
              if (state is TvPopularHasData) {
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
                      title: movies.tvName ?? '',
                      rating: movies.voteAverage ?? 0.0,
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
              } else if (state is TvPopularLoading) {
                return ShimmerCard();
              } else if (state is TvPopularError) {
                return CustomErrorWidget(message: state.errorMessage);
              } else if (state is TvPopularNoData) {
                return CustomErrorWidget(message: state.message);
              } else if (state is TvPopularNoInternetConnection) {
                return NoInternetWidget(
                  message: AppConstant.noInternetConnection,
                  onPressed: () => _loadTvPopular(context),
                );
              } else {
                return Center(child: Text(""));
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
