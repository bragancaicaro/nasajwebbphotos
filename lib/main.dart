import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nasajwebbphotos/firebase_options.dart';
import 'package:nasajwebbphotos/repository/image_repository.dart';

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
  late ImageRepository _imageRepository;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_imageRepository.isLoading) {
        page++;
        print(page);
        _loadListImage(page: page);
      }
    });

    _loadListImage(page: page);

    super.initState();
  }

  void _loadListImage({required page}) async {
    final urlListImage =
        'https://www.flickr.com/services/rest/?api_key=$flickrApiKey&method=flickr.people.getPhotos&format=json&nojsoncallback=1&user_id=50785054@N03&page=${page}';

    _imageRepository = ImageRepository(initialUrl: urlListImage);
    await _imageRepository.fetchListImages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Container(
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.white, width: 1))),
          child: Align(
            alignment: Alignment.center,
            child: Text('NASA\'s James Webb Photos',
                style:
                    GoogleFonts.bebasNeue(color: Colors.white, fontSize: 25)),
          ),
        ),
      ),
      body: MasonryGridView.builder(
        controller: _scrollController,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: _imageRepository.images.length,
        itemBuilder: (context, index) {
          final image = _imageRepository.images[index];
          return Image.network(
            'https://live.staticflickr.com/${image.server}/${image.id}_${image.secret}.jpg',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
