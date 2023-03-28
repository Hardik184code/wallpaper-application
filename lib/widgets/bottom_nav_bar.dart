import 'package:flutter/material.dart';
import 'package:new_wallpaper_001/utils/my_state.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.pageController});

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final pageState = Provider.of<PageState>(context);
    return BottomNavigationBar(
      elevation: 0,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      enableFeedback: true,
      onTap: (index) {
        pageState.changePage(index);
        pageController.jumpToPage(index);
      },
      currentIndex: pageState.currentPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined),
          label: "Explore",
          activeIcon: Icon(Icons.explore),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "Favourite",
          activeIcon: Icon(Icons.favorite),
        ),
      ],
    );
  }
}
