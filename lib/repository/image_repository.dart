import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nasajwebbphotos/model/image_model.dart';

class ImageRepository {
  String? _nextPage;
  bool _isLoading = false;
  final String initialUrl;
  final List<ImageModel> _images = [];

  bool get isLoading => _isLoading;
  List<ImageModel> get images => List.from(_images);
  ImageRepository({required this.initialUrl});

  Future<void> fetchListImages({String? url}) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    print(_isLoading);
    var requestUrl = Uri.parse(url ?? _nextPage ?? initialUrl);
    try {
      final response = await http.get(requestUrl);
      _isLoading = false;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final photos = data['photos']['photo'] as List;
        for (var json in photos) {
          _images.add(ImageModel.fromJson(json));
        }
        _images.forEach(
            (img) => print("Image ID: ${img.id}, Title: ${img.title}"));
        print("Images loaded: ${_images.length}");
      } else {
        throw Exception(
            'Failed to load items. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _isLoading = false;
      print("Error fetching images: $e");
    }
  }
}
