import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference images =
      FirebaseFirestore.instance.collection('images');
  Future<void> addLikeImage(String idImage) async {
    try {
      final doc = await images.doc(idImage).get();
      if (!doc.exists) {
        await initializeImageCounters(idImage);
      }
      await images.doc(idImage).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error + like: $e");
    }
  }

  Future<void> addDownloadImage(String idImage) async {
    try {
      final doc = await images.doc(idImage).get();
      if (!doc.exists) {
        await initializeImageCounters(idImage);
      }
      await images.doc(idImage).update({
        'downloads': FieldValue.increment(1),
      });
    } catch (e) {
      print("Error + downloads: $e");
    }
  }

  Future<void> initializeImageCounters(String idImage) async {
    try {
      await images.doc(idImage).set({
        'likes': 0,
        'downloads': 0,
      });
    } catch (e) {
      print("Error init counters: $e");
    }
  }

  Stream<DocumentSnapshot> getImageData(String idImage) {
    return images.doc(idImage).snapshots();
  }
}
