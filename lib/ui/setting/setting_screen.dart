import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:moviecatalogue/ui/about/about_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:shared/shared.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/theme';

  Future<String> _getVersion() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Container(
          // height: Sizes.dp30(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '© 2024 Movie Catalogue',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Updated by Mohammed Ragheb',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FutureBuilder<String>(
                      future: _getVersion(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        var verInfo = "";
                        if (snapshot.hasData) {
                          verInfo = "v ${snapshot.data}";
                          return Container(
                            child: Text(
                              verInfo,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                  icon: Image.asset(
                    ImagesAssets.github,
                    scale: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ColorPalettes.white
                        : ColorPalettes.black,
                  ),
                  onPressed: () {
                    Navigation.launchURL(
                        Uri.parse(UrlConstant.urlGitHubUpdater));
                  }),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(Sizes.dp10(context)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text('Deleveloper'),
              onTap: () => Navigation.intent(context, AboutScreen.routeName),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: Sizes.dp16(context),
              ),
            ),
            Divider(height: 0),
            ListTile(
              title: Text('Theme'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: Sizes.dp16(context),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomDialog(
                    themeMode: context.read<ThemeBloc>().state.themeMode,
                    onChanged: (value) {
                      if (value == null) return;
                      context.read<ThemeBloc>().add(ChangeThemeMode(value));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
