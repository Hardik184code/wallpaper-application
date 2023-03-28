import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:new_wallpaper_001/models/image_model.dart';
import 'package:new_wallpaper_001/models/topics_model.dart';
import 'package:new_wallpaper_001/providers/keys.dart';

class GetImages {
  Future<String> getKey() async {
    String apiKey = unsplashApiClientID;
    return apiKey;
  }

  // collection images get and use unsplash collection images url
  Future<List<ImageModel>> getCollectionImages(
      String id, int page, int perPage) async {
    String apiKey = await getKey();
    final response = await http.get(
      Uri.parse(
        'https://api.unsplash.com/collections/$id/photos?client_id=$apiKey&page=$page&per_page=$perPage',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(
        response.body,
      );
      List<ImageModel> images =
          result.map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } else {
      throw "Can't get images";
    }
  }

  // random images get and use unsplash random images url
  Future<List<ImageModel>> getRandomImages() async {
    String apiKey = await getKey();
    final response = await http.get(
      Uri.parse(
        'https://api.unsplash.com/photos/random/?client_id=$apiKey&count=30',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(
        response.body,
      );
      List<ImageModel> images =
          result.map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } else {
      throw "Can't get images";
    }
  }

  // this function get topics json data for images all topics
  Future<List<TopicsModel>> getTopicsModel() async {
    final topicsJson = await rootBundle.loadString(
      "assets/files/topics.json",
    );
    final topicsData = jsonDecode(
      topicsJson,
    );
    var topics = topicsData['topics'];
    List<TopicsModel> topicsList =
        List.from(topics).map((e) => TopicsModel.fromJson(e)).toList();
    return topicsList;
  }

  // this function is get all data topics of images
  Future<List<ImageModel>> getTopic({
    required String topic,
    required int pageNo,
  }) async {
    String apiKey = await getKey();
    final response = await http.get(
      Uri.parse(
        'https://api.unsplash.com/topics/$topic/photos/?client_id=$apiKey&per_page=30&page=$pageNo',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(
        response.body,
      );
      List<ImageModel> images =
          result.map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } else {
      throw "Can't get images";
    }
  }

  // search images get and use unsplash search images url
  Future<List<ImageModel>> searchImage({
    required query,
  }) async {
    String apiKey = await getKey();
    final response = await http.get(
      Uri.parse(
        'https://api.unsplash.com/photos/random/?client_id=$apiKey&count=30&query=$query',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(
        response.body,
      );
      List<ImageModel> images =
          result.map((e) => ImageModel.fromJson(e)).toList();
      return images;
    } else {
      throw "Can't get images";
    }
  }
}
