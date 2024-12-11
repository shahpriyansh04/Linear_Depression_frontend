import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcons {
  static Widget pdf({double size = 24}) {
    return SvgPicture.asset(
      'assets/pdf_icon.svg',
      width: size,
      height: size,
    );
  }

  static Widget audio({double size = 24}) {
    return SvgPicture.asset(
      'assets/audio_icon.svg',
      width: size,
      height: size,
    );
  }

  static Widget video({double size = 24}) {
    return SvgPicture.asset(
      'assets/video_icon.svg',
      width: size,
      height: size,
    );
  }

  static Widget file({double size = 24}) {
    return SvgPicture.asset(
      'assets/file_icon.svg',
      width: size,
      height: size,
    );
  }
}

