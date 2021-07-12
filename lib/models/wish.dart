class Wish{
  String title;
  String? description;

  String? link;
  List<String>? filesList;

  List<String>? listPicURL;

  Wish({required this.title, this.description, this.link,
    this.listPicURL, this.filesList});
}