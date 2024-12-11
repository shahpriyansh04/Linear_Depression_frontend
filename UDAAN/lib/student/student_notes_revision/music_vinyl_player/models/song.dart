import 'album.dart';

class Song {
  const Song({
    required this.title,
    required this.duration,
    required this.album,
  });

  final String title;
  final Duration duration;
  final Album album;
}
