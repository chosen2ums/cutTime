class Media {
  int id;
  String name;
  String path;

  Media({
    this.id,
    this.name,
    this.path,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return null;
    else
      return Media(
        id: json['id'],
        name: json['image_name'],
        path: json['image_path'],
      );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_name': name,
        'image_path': path,
      };
}
