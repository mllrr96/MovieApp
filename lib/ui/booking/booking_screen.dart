import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/dashboard/dashboard_screen.dart';
import 'package:shared/shared.dart';

class BookingScreen extends StatelessWidget {
  static const routeName = '/booking';

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final _isDarkTheme = themeData.brightness == Brightness.dark;
    final ScreenArguments? args =
        ModalRoute.of(context)?.settings.arguments as ScreenArguments?;
    return Scaffold(
      backgroundColor:
          !_isDarkTheme ? ColorPalettes.darkPrimary : ColorPalettes.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(args?.movies.title ?? args?.movies.tvName ?? ''),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(Sizes.dp20(context)),
          child: Column(
            children: <Widget>[
              DateWidget(),
              TimeWidget(),
              CinemaWidget(movieBackground: args?.movies.backdropPath ?? ''),
              Padding(
                padding: EdgeInsets.only(
                  top: Sizes.dp20(context),
                ),
                child: CustomButton(
                  text: "Pay",
                  onPressed: () {
                    SmoothDialog(
                      context: context,
                      path: ImagesAssets.successful,
                      mode: SmoothMode.Lottie,
                      content: "Thanks for your movie ticket order",
                      title: "Payment Successful!",
                      submit: () {
                        Navigation.intentWithClearAllRoutes(
                            context, DashBoardScreen.routeName);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
