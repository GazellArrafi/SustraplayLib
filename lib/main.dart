import "package:flutter/material.dart";
import "package:flutter_dropdown_alert/dropdown_alert.dart";
import "package:provider/provider.dart";
import "package:sustraplay_abp/data/getUsers.dart";
import "package:sustraplay_abp/pages/detailPage.dart";
import "package:sustraplay_abp/pages/favoritePage.dart";
import "package:sustraplay_abp/pages/homePage.dart";
import "package:sustraplay_abp/pages/loginPage.dart";
import "package:sustraplay_abp/pages/registerPage.dart";
import "package:sustraplay_abp/pages/searchPage.dart";
import "package:sustraplay_abp/pages/settingPage.dart";
import 'package:sustraplay_abp/pages/statistikPage.dart';
import "package:sustraplay_abp/providerTheme.dart";
import "package:go_router/go_router.dart";

void main(){
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProviderTheme(),
      child: MainPage(),
    )
  );
}

final GoRouter routeLogin = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return LoginPage();
      }
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: '/homePage',
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/statistikPage/:idGame',
      builder: (context, state) {
        final idGame = state.pathParameters['idGame'];
        return StatistikPage(idGame: idGame!);
      },
    ),
    GoRoute(
      path: '/detailPage/:idGame',
      builder: (context, state) {
        final idGame = state.pathParameters['idGame'];
        return DetailPage(idGame: idGame!,);
      },
    ),
    GoRoute(
      path: '/searchPage',
      builder: (context, state) {
        return SearchPage();
      },
    ),
    GoRoute(
      path: '/settingPage',
      builder: (context, state) {
        return SettingPage();
      },
    ),
    GoRoute(
      path: '/favoritePage',
      builder: (context, state) {
        return FavoritePage();
      },
    ),
    GoRoute(
      path: '/mainPage',
      builder: (context, state) {
        return MainPage();
      },
    ),
  ],
);

final GoRouter routeLogined = GoRouter(
  routes: [
    GoRoute(
      path: '/loginPage',
      builder: (context, state) {
        return LoginPage();
      }
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return RegisterPage();
      },
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      path: '/statistikPage/:idGame',
      builder: (context, state) {
        final idGame = state.pathParameters['idGame'];
        return StatistikPage(idGame: idGame!);
      },
    ),
    GoRoute(
      path: '/detailPage/:idGame',
      builder: (context, state) {
        final idGame = state.pathParameters['idGame'];
        return DetailPage(idGame: idGame!,);
      },
    ),
    GoRoute(
      path: '/searchPage',
      builder: (context, state) {
        return SearchPage();
      },
    ),
    GoRoute(
      path: '/settingPage',
      builder: (context, state) {
        return SettingPage();
      },
    ),
    GoRoute(
      path: '/favoritePage',
      builder: (context, state) {
        return FavoritePage();
      },
    ),
    GoRoute(
      path: '/mainPage',
      builder: (context, state) {
        return MainPage();
      },
    ),
  ],
);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snap) {
        return MaterialApp.router(
          builder: (context, child) {
            return Stack(
              children: [
                child!,
                DropdownAlert(),
              ],
            );
          },
          routerConfig: snap.data?['id'] == null ? routeLogin : routeLogined,
          theme: Provider.of<ProviderTheme>(context).setTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}