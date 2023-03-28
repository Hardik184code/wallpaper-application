import 'package:shared_preferences/shared_preferences.dart';

class PrefManager {
  toggleFavourite(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myFavouriteList = prefs.getStringList("favouriteList");
    if (myFavouriteList != null) {
      if (myFavouriteList.contains(url)) {
        myFavouriteList.remove(url);
        await prefs.setStringList("favouriteList", myFavouriteList);
      } else {
        myFavouriteList.add(url);
        await prefs.setStringList("favouriteList", myFavouriteList);
      }
    } else {
      await prefs.setStringList("favouriteList", [url]);
    }
  }

  Future<bool> isFavourite(url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myFavouriteList = prefs.getStringList("favouriteList");
    if (myFavouriteList != null) {
      if (myFavouriteList.contains(url)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<String>> getFavouriteList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myFavouriteList = prefs.getStringList("favouriteList");
    if (myFavouriteList != null) {
      return myFavouriteList;
    } else {
      return [];
    }
  }

  saveThemeIndex(int themeIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("themeIndex", themeIndex);
  }

  Future<int> getThemeIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt("themeIndex");
    if (themeIndex != null) {
      return themeIndex;
    } else {
      return 0;
    }
  }

  saveAccentIndex(int accentIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("accentIndex", accentIndex);
  }

  Future<int> getAccentIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final accentIndex = prefs.getInt("accentIndex");
    if (accentIndex != null) {
      return accentIndex;
    } else {
      return 0;
    }
  }
}
