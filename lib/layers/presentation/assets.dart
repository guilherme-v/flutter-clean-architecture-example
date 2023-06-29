import 'dart:ui';

class Asset {
  // ---------------------------------------------------------------------------
  // Images
  // ---------------------------------------------------------------------------
  static const String _img = 'assets/images';

  static const String bgBase = '$_img/bg-base.jpg';
  static const String bgLightReceive = '$_img/bg-light-receive.png';
  static const String mgBaseBottom = '$_img/mg-base-bottom.png';
  static const String mgLightReceiveBottom =
      '$_img/mg-light-receive-bottom.png';
  static const String mgLightEmitBottom = '$_img/mg-light-emit-bottom.png';
  static const String fgBase = '$_img/fg-base.png';
  static const String fgLightReceive = '$_img/fg-light-receive.png';
  static const String fgEmit = '$_img/fg-emit.png';

  static const String cardBorderBottomLeft = '$_img/border-bottom-left.png';
  static const String cardBorderTopRight = '$_img/border-top-right.png';
  static const String cardBorderTopLeft = '$_img/border-top-left.png';
  static const String cardBorderBottomRight = '$_img/border-bottom-right.png';

  // ---------------------------------------------------------------------------
  // Shaders
  // ---------------------------------------------------------------------------
  static const String _shaders = 'assets/shaders';
  static const String uiShader = '$_shaders/ui_glitch.frag';
}

// -----------------------------------------------------------------------------
// Fragments
// -----------------------------------------------------------------------------
typedef FragmentPrograms = ({FragmentProgram ui});

Future<FragmentPrograms> loadFragmentPrograms() async =>
    (ui: (await _loadFragmentProgram(Asset.uiShader)),);

Future<FragmentProgram> _loadFragmentProgram(String path) async {
  return (await FragmentProgram.fromAsset(path));
}
