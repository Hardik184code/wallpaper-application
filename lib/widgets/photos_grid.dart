import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/widgets/images_view.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotosView extends StatelessWidget {
  const PhotosView({
    super.key,
    required this.images,
    required this.scrollController,
    this.isNormalGrid = false,
  });

  final List<ImageModel> images;
  final ScrollController scrollController;

  final bool isNormalGrid;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 12,
      controller: scrollController,
      itemCount: images.length,
      itemBuilder: (BuildContext context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(images: images[index]),
                ));
          },
          child: Hero(
            tag: images[index].id,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: isNormalGrid
                      ? images[index].urls.regular
                      : images[index].urls.small,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
