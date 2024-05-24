import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:playground_1/common_libs.dart';
import 'package:playground_1/logic/common/platform_info.dart';

class AppBitmaps {
  static late final BitmapDescriptor mapMarker;

  static Future<void> init() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: PlatformInfo.pixelRatio),
      '${ImagePaths.common}/location-pin.png',
    );
  }
}

class ImagePaths {
  static String root = 'assets/images';
  static String common = 'assets/images/_common';
  static String cloud = '$common/cloud-white.png';

  static String collectibles = '$root/collectibles';
  static String particle = '$common/particle-21x23.png';
  static String ribbonEnd = '$common/ribbon-end.png';

  static String textures = '$common/texture';
  static String icons = '$common/icons';

  static String roller1 = '$textures/roller-1-white.gif';
  static String roller2 = '$textures/roller-2-white.gif';

  static String appLogo = '$common/app-logo.png';
  static String appLogoPlain = '$common/app-logo-plain.png';
}

class SvgPaths {
  static String compassFull = '${ImagePaths.common}/compass-full.svg';
  static String compassSimple = '${ImagePaths.common}/compass-simple.svg';
}

extension WonderAssetExtensions on WonderType {
  String get assetPath {
    return switch (this) {
      WonderType.greatWall => '${ImagePaths.root}/great_wall_of_china',
      // WonderType.pyramidsGiza => '${ImagePaths.root}/pyramids',
      // WonderType.petra => '${ImagePaths.root}/petra',
      // WonderType.colosseum => '${ImagePaths.root}/colosseum',
      // WonderType.chichenItza => '${ImagePaths.root}/chichen_itza',
      // WonderType.machuPicchu => '${ImagePaths.root}/machu_picchu',
      // WonderType.tajMahal => '${ImagePaths.root}/taj_mahal',
      // WonderType.christRedeemer => '${ImagePaths.root}/christ_the_redeemer'
    };
  }

  String get homeBtn => '$assetPath/wonder-button.png';
  String get photo1 => '$assetPath/photo-1.jpg';
  String get photo2 => '$assetPath/photo-2.jpg';
  String get photo3 => '$assetPath/photo-3.jpg';
  String get photo4 => '$assetPath/photo-4.jpg';
  String get flattened => '$assetPath/flattened.jpg';
}
