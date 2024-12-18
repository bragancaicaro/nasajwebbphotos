class ImageModel {
  String id;
  String server;
  String secret;
  String? size;
  String title;
  ImageModel(
      {required this.id,
      required this.server,
      required this.secret,
      this.size,
      required this.title});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      secret: json['secret'],
      server: json['server'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'secret': secret,
      'server': server,
      'title': title,
    };
  }
}
