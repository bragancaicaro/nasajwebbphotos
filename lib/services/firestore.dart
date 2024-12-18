import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference images =
      FirebaseFirestore.instance.collection('images');

  Future<void> addLikeImage(String idImage) {
    return images.add({
      'likeImage': images.id,
    });
  }
  Future<void> addDownloadImage(String idImage) {
    return images.add({
      'downloadImage': images.id,
    });
  }
}
