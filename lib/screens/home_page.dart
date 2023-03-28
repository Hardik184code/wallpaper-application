import 'package:flutter/material.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/providers/get_images.dart';
import 'package:new_wallpaper_001/widgets/photos_grid.dart';
import 'package:new_wallpaper_001/utils/search_bar_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<ImageModel> myImage = [];

  @override
  void initState() {
    super.initState();
    getAwesomeStart();
    scrolls.addListener(() {
      if (scrolls.position.pixels == scrolls.position.maxScrollExtent) {
        getMyImages();
      }
    });
  }

  void getAwesomeStart() async {
    List<ImageModel> images = await image.getCollectionImages('2423569', 1, 20);
    setState(() {
      for (var image in images) {
        myImage.add(image);
      }
    });
  }

  void getMyImages() async {
    List<ImageModel> images = await image.getRandomImages();
    setState(() {
      for (var image in images) {
        myImage.add(image);
      }
    });
  }

  final GetImages image = GetImages();
  ScrollController scrolls = ScrollController();

  @override
  void dispose() {
    scrolls.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: [
            const Text(
              "Un",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Splash",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchBarDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: PhotosView(
        images: myImage,
        scrollController: scrolls,
      ),
    );
  }
}
