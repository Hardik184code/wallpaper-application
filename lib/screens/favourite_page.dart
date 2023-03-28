import 'package:flutter/material.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/utils/pref_manager.dart';
import 'package:new_wallpaper_001/widgets/photos_grid.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  void initState() {
    getImageModels();
    super.initState();
  }

  ScrollController scrolls = ScrollController();
  List<ImageModel> myImages = [];
  PrefManager prefs = PrefManager();

  Future<void> getImageModels() async {
    final favourite = await prefs.getFavouriteList();
    if (favourite.isNotEmpty) {
      for (var url in favourite) {
        final imagedata = {
          "id": "",
          "urls": {
            "small": "",
            "raw": "",
            "regular": url,
            "thumb": "",
            "full": "",
          },
        };
        setState(() {
          myImages.add(ImageModel.fromJson(imagedata));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myImages.isEmpty
          ? const NoFavouritePage()
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                  constraints: const BoxConstraints.expand(height: 50),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Favourites",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PhotosView(
                    images: myImages,
                    scrollController: scrolls,
                    isNormalGrid: true,
                  ),
                ),
              ],
            ),
    );
  }
}

class NoFavouritePage extends StatelessWidget {
  const NoFavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/heart.png",
            height: 80,
            width: 80,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "You have no favourite yet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
