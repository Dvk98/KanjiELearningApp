import 'package:flame/palette.dart';
import 'package:flame/components.dart';

class Common {
  static final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
  static final highlightPaint = BasicPalette.white.withAlpha(255).paint();
  static final redPaint = BasicPalette.red.paint();
  static final greenPaint = BasicPalette.green.paint();
  static final regularTextConfig = TextPaintConfig(
      color: BasicPalette.white.color, fontFamily: "Togalite", fontSize: 30);
  static final regular =
      TextPaint(config: regularTextConfig.withFontFamily("Togalite"));
}
