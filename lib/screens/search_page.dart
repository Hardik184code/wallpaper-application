import 'package:flutter/material.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/providers/get_images.dart';
import 'package:new_wallpaper_001/widgets/photos_grid.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.query});

  final String query;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    getImages(widget.query);
    scrolls.addListener(() {
      if (scrolls.position.pixels == scrolls.position.maxScrollExtent) {
        getImages(widget.query);
      }
    });
    super.initState();
  }

  List<ImageModel> myImages = [];

  getImages(query) async {
    List<ImageModel> images = await image.searchImage(query: query);
    setState(() {
      for (var element in images) {
        myImages.add(element);
      }
    });
  }

  GetImages image = GetImages();
  ScrollController scrolls = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PhotosView(
      images: myImages,
      scrollController: scrolls,
      isNormalGrid: false,
    );
  }
}
