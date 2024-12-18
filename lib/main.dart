import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nasajwebbphotos/firebase_options.dart';
import 'package:nasajwebbphotos/model/image_model.dart';
import 'package:nasajwebbphotos/repository/image_repository.dart';
import 'package:nasajwebbphotos/services/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NASA\'s James Webb Photos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const flickrApiKey = String.fromEnvironment('FLICKR_API_KEY');
  final FirestoreService firestoreService = FirestoreService();
  late ImageRepository _imageRepository;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();

    // Inicializa o repositório apenas uma vez
    _imageRepository = ImageRepository(
      initialUrl:
          'https://www.flickr.com/services/rest/?api_key=$flickrApiKey&method=flickr.people.getPhotos&format=json&nojsoncallback=1&user_id=50785054@N03',
    );

    // Adiciona listener para carregar mais imagens ao rolar
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_imageRepository.isLoading) {
        page++;
        _loadListImage(page: page);
      }
    });

    // Carrega a primeira página de imagens
    _loadListImage(page: page);
  }

  void _loadListImage({required int page}) async {
    final urlListImage =
        'https://www.flickr.com/services/rest/?api_key=$flickrApiKey&method=flickr.people.getPhotos&format=json&nojsoncallback=1&user_id=50785054@N03&page=$page';

    // Chama o método de carregamento sem recriar o repositório
    await _imageRepository.fetchListImages(url: urlListImage);

    // Atualiza o estado para exibir as novas imagens
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = MediaQuery.of(context).size.width < 600
        ? 2
        : MediaQuery.of(context).size.width > 1024
            ? 4
            : 3;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'NASA\'s James Webb Photos',
              style: GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25),
            ),
          ),
        ),
      ),
      body: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1,
        ),
        itemCount: _imageRepository.images.length,
        itemBuilder: (context, index) {
          final image = _imageRepository.images[index];
          return imageWidget(context, image, firestoreService);
        },
      ),
    );
  }

  @override
  Widget imageWidget(BuildContext context, ImageModel image,
      FirestoreService firestoreService) {
    return GestureDetector(
      onTap: () {
        _showFullImage(context, image, firestoreService);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            // Imagem de fundo
            Image.network(
              'https://live.staticflickr.com/${image.server}/${image.id}_${image.secret}.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

            StreamBuilder<DocumentSnapshot>(
              stream: firestoreService.getImageData(image.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return countersOverlay(0, 0, image, firestoreService);
                }

                final data =
                    snapshot.data?.data() as Map<String, dynamic>? ?? {};
                final likes = data['likes'] ?? 0;
                final downloads = data['downloads'] ?? 0;

                return countersOverlay(
                    likes, downloads, image, firestoreService);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget countersOverlay(int likes, int downloads, ImageModel image,
      FirestoreService firestoreService) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botão de like
            Row(
              children: [
                IconButton(
                  onPressed: () => firestoreService.addLikeImage(image.id),
                  icon: const Icon(Icons.favorite, color: Colors.red),
                ),
                Text(
                  likes.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            // Botão de download
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    downloadImage(
                      'https://live.staticflickr.com/${image.server}/${image.id}_${image.secret}_b.jpg',
                      '${image.title}.jpg',
                    );

                    firestoreService.addDownloadImage(image.id);
                  },
                  icon: const Icon(Icons.download, color: Colors.blue),
                ),
                Text(
                  downloads.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullImage(BuildContext context, ImageModel image,
      FirestoreService firestoreService) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(), // Fechar ao clicar fora
          child: Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero, // Remover margens
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://live.staticflickr.com/${image.server}/${image.id}_${image.secret}_b.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: firestoreService.getImageData(image.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return countersOverlay(0, 0, image, firestoreService);
                      }

                      final data =
                          snapshot.data?.data() as Map<String, dynamic>? ?? {};
                      final likes = data['likes'] ?? 0;
                      final downloads = data['downloads'] ?? 0;

                      return countersOverlay(
                          likes, downloads, image, firestoreService);
                    },
                  ),
                ),
                Positioned(
                  top: 16.0,
                  right: 16.0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void downloadImage(String imageUrl, String fileName) {
    final anchor = html.AnchorElement(href: imageUrl)
      ..target = 'blank'
      ..download = fileName;
    anchor.click();
    anchor.remove();
  }
}
