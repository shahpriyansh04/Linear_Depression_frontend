class Album {
  const Album({
    this.subject,
    this.pathImage,
    this.duration = const Duration(minutes: 74),
    this.description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting "
            "industry. Lorem Ipsum has been the industry's standard dumm"
            "y text ever since the 1500s, when an unknown printer took a"
            " galley of type and scrambled it to make a type specimen boo"
            "k. It has survived not only five centuries, but also the lea"
            "p into electronic typesetting, remaining essentially unchang"
            "ed. It was popularised in the 1960s with the release of Let"
            "raset sheets containing Lorem Ipsum passages, and more recen"
            "tly with desktop publishing software like Aldus PageMaker inc"
            "luding versions of Lorem Ipsum.",
  });
  final String? subject;
  final String? pathImage;
  final String description;
  final Duration duration;
  // final List<String> genres;

  static const listAlbum = [
    Album(
      subject: 'Math',
      pathImage: 'assets/img/music/zombie.jpg',
    ),
    Album(
      subject: 'Science',
      pathImage: 'assets/img/music/jueves.jpg',
    ),
    Album(
      subject: 'History',
      pathImage: 'assets/img/music/espejo.jpg',
    ),
    Album(
      // title: 'Porfiado',
      // author: 'Cuarteto de nos',
      // rate: 4.4,
      subject: 'English',
      pathImage: 'assets/img/music/porfiado.jpg',
      // year: 2011,
    ),
    Album(
      subject: 'Geography',
      pathImage: 'assets/img/music/bipolar.jpg',
    ),
    Album(
      subject: 'Art',
      pathImage: 'assets/img/music/raro.jpg',
    ),
    Album(
      subject: 'Music',
      pathImage: 'assets/img/music/cortamanbo.jpg',
    ),
  ];
}
