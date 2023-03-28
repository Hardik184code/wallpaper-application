import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:new_wallpaper_001/screens/explore_page.dart';
import 'package:new_wallpaper_001/screens/favourite_page.dart';
import 'package:new_wallpaper_001/screens/home_page.dart';
import 'package:new_wallpaper_001/utils/my_state.dart';
import 'package:new_wallpaper_001/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  List<Widget> pages = [
    const HomePage(),
    const ExplorePage(),
    const FavouritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeState()),
        ChangeNotifierProvider(create: (context) => PageState()),
      ],
      builder: (context, _) {
        final themeState = Provider.of<ThemeState>(context);
        final pageState = Provider.of<PageState>(context);
        themeState.getTheme();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: WillPopScope(
            onWillPop: () async {
              if (pageState.currentPage != 0) {
                pageState.changePage(0);
                controller.jumpTo(0);
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: PageView(
                physics: const BouncingScrollPhysics(),
                controller: controller,
                children: pages,
                onPageChanged: (index) {
                  pageState.changePage(index);
                },
              ),
              bottomNavigationBar: BottomNavBar(
                pageController: controller,
              ),
            ),
          ),
          themeMode: themeState.currentThemeMode,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.white,
            primaryColor: Colors.white,
            colorScheme: const ColorScheme.light(),
          ),
          darkTheme: themeState.getDarkTheme(),
        );
      },
    );
  }
}
