import 'package:flutter/material.dart';
import 'package:udaan_app/student/student_notes_revision/music_vinyl_player/models/album.dart';
import 'package:udaan_app/student/student_notes_revision/music_vinyl_player/ui/my_library/widgets/row_stars.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.album,
    this.padding,
  });

  final Album album;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(-10, 10),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //--------------------------
          // Text and stars
          //--------------------------
          Row(
            children: <Widget>[
              Text(
                'Class Notes',
                style: GoogleFonts.spectral(
                  color: const Color(0xffd4af90),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          //----------------------------------
          // Album Description
          //----------------------------------
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                album.description,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          //----------------------------------
          // Album Genres
          //----------------------------------
          SizedBox(
            height: 45,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 5),
            ),
          )
        ],
      ),
    );
  }

  WidgetSpan _buildDotSpan() {
    return WidgetSpan(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: _Dot(
          sizeDot: 4,
          color: Colors.grey[400],
        ),
      ),
      alignment: PlaceholderAlignment.middle,
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    this.sizeDot,
    this.color,
  });
  final double? sizeDot;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: sizeDot,
      height: sizeDot,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(sizeDot!),
        color: color,
      ),
    );
  }
}
