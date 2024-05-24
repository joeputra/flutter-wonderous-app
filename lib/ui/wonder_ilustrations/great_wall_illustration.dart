import 'package:playground_1/common_libs.dart';
import 'package:playground_1/ui/common/fade_color_transition.dart';
import 'package:playground_1/ui/wonder_ilustrations/common/illustration_piece.dart';
import 'package:playground_1/ui/wonder_ilustrations/common/paint_textures.dart';
import 'package:playground_1/ui/wonder_ilustrations/common/wonder_illustration_builder.dart';
import 'package:playground_1/ui/wonder_ilustrations/common/wonder_illustration_config.dart';

class GreatWallIllustration extends StatelessWidget {
  GreatWallIllustration({super.key, required this.config});
  final WonderIllustrationConfig config;
  final String assetPath = WonderType.greatWall.assetPath;
  final fgColor = WonderType.greatWall.fgColor;
  final bgColor = WonderType.greatWall.bgColor;

  @override
  Widget build(BuildContext context) {
    return WonderIllustrationBuilder(
      config: config,
      bgBuilder: _buildBg,
      mgBuilder: _buildMg,
      fgBuilder: _buildFg,
      wonderType: WonderType.greatWall,
    );
  }

  List<Widget> _buildBg(BuildContext context, Animation<double> anim) {
    return [
      FadeColorTransition(
          animation: anim, color: $styles.colors.shift(fgColor, .15)),
      Positioned.fill(
        child: IllustrationTexture(
          ImagePaths.roller2,
          flipX: true,
          color: const Color(0xff688750),
          opacity: anim.drive(Tween(begin: 0, end: 1)),
          scale: config.shortMode ? 4 : 1.15,
        ),
      ),
      IllustrationPiece(
        fileName: 'sun.png',
        initialOffset: const Offset(0, 50),
        enableHero: true,
        heightFactor: config.shortMode ? .07 : .25,
        minHeight: 120,
        offset: config.shortMode
            ? Offset(-40, context.heightPx * -.06)
            : Offset(-65, context.heightPx * -.3),
      ),
    ];
  }

  List<Widget> _buildMg(BuildContext context, Animation<double> anim) {
    return [
      IllustrationPiece(
        fileName: 'great-wall.png',
        heightFactor: config.shortMode ? .45 : .65,
        minHeight: 250,
        zoomAmt: .05,
        enableHero: true,
        fractionalOffset: Offset(0, config.shortMode ? .15 : -.15),
      ),
    ];
  }

  List<Widget> _buildFg(BuildContext context, Animation<double> anim) {
    return [
      const IllustrationPiece(
        fileName: 'foreground-left.png',
        alignment: Alignment.bottomCenter,
        initialScale: .9,
        initialOffset: Offset(-40, 60),
        heightFactor: .85,
        fractionalOffset: Offset(-.4, .45),
        zoomAmt: .25,
        dynamicHzOffset: -150,
      ),
      const IllustrationPiece(
        fileName: 'foreground-right.png',
        alignment: Alignment.bottomCenter,
        initialOffset: Offset(20, 40),
        initialScale: .95,
        heightFactor: 1,
        fractionalOffset: Offset(.4, .3),
        zoomAmt: .1,
        dynamicHzOffset: 150,
      ),
    ];
  }
}
