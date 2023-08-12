import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

@immutable
class CustomTheme extends ThemeExtension<CustomTheme> {
  const CustomTheme({
    this.primaryColor = const Color(0xFF6750A4),
    this.tertiaryColor = const Color(0xFF625B71),
    this.neutralColor = const Color(0xFF939094),
  });

  final Color primaryColor;
  final Color tertiaryColor;
  final Color neutralColor;

  Scheme _schemeLight() {
    final base = CorePalette.of(primaryColor.value);
    final primary = base.primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
    final neutral = CorePalette.of(neutralColor.value).neutral;
    return Scheme(
      primary: primary.get(40),
      onPrimary: primary.get(100),
      primaryContainer: primary.get(90),
      onPrimaryContainer: primary.get(10),
      secondary: base.secondary.get(40),
      onSecondary: base.secondary.get(100),
      secondaryContainer: base.secondary.get(90),
      onSecondaryContainer: base.secondary.get(10),
      tertiary: tertiary.get(40),
      onTertiary: tertiary.get(100),
      tertiaryContainer: tertiary.get(90),
      onTertiaryContainer: tertiary.get(10),
      error: base.error.get(40),
      onError: base.error.get(100),
      errorContainer: base.error.get(90),
      onErrorContainer: base.error.get(10),
      background: neutral.get(98),
      onBackground: neutral.get(6),
      surface: neutral.get(99),
      onSurface: neutral.get(10),
      outline: base.neutralVariant.get(50),
      outlineVariant: base.neutralVariant.get(80),
      surfaceVariant: base.neutralVariant.get(90),
      onSurfaceVariant: base.neutralVariant.get(30),
      shadow: neutral.get(0),
      scrim: neutral.get(0),
      inverseSurface: neutral.get(20),
      inverseOnSurface: neutral.get(95),
      inversePrimary: primary.get(40),
    );
  }

  Scheme _schemeDark() {
    final base = CorePalette.of(primaryColor.value);
    final primary = base.primary;
    final tertiary = CorePalette.of(tertiaryColor.value).primary;
    final neutral = CorePalette.of(neutralColor.value).neutral;
    return Scheme(
      primary: primary.get(80),
      onPrimary: primary.get(20),
      primaryContainer: primary.get(30),
      onPrimaryContainer: primary.get(90),
      secondary: base.secondary.get(80),
      onSecondary: base.secondary.get(20),
      secondaryContainer: base.secondary.get(30),
      onSecondaryContainer: base.secondary.get(90),
      tertiary: tertiary.get(80),
      onTertiary: tertiary.get(20),
      tertiaryContainer: tertiary.get(30),
      onTertiaryContainer: tertiary.get(90),
      surface: neutral.get(6),
      onSurface: neutral.get(90),
      background: neutral.get(6),
      onBackground: neutral.get(90),
      error: base.error.get(80),
      onError: base.error.get(20),
      errorContainer: base.error.get(30),
      onErrorContainer: base.error.get(90),
      outline: base.neutralVariant.get(60),
      outlineVariant: base.neutralVariant.get(30),
      surfaceVariant: base.neutralVariant.get(30),
      onSurfaceVariant: base.neutralVariant.get(80),
      shadow: neutral.get(0),
      scrim: neutral.get(0),
      inverseSurface: neutral.get(90),
      inverseOnSurface: neutral.get(20),
      inversePrimary: primary.get(40),
    );
  }

  ThemeData _base(final ColorScheme colorScheme) {
    final primaryTextTheme = GoogleFonts.exoTextTheme();
    final secondaryTextTheme = GoogleFonts.neuchaTextTheme();
    final textTheme = primaryTextTheme.copyWith(
      displaySmall: secondaryTextTheme.displaySmall,
      displayMedium: secondaryTextTheme.displayMedium,
      displayLarge: secondaryTextTheme.displayLarge,
      headlineSmall: secondaryTextTheme.headlineSmall,
      headlineMedium: secondaryTextTheme.headlineMedium,
      headlineLarge: secondaryTextTheme.headlineLarge,
    );

    return ThemeData(
      useMaterial3: true,
      extensions: [this],
      colorScheme: colorScheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        toolbarHeight: 152,
        color: colorScheme.surface.withOpacity(0.95),
      ),
      cardTheme: CardTheme(color: colorScheme.surfaceVariant),
      // scaffoldBackgroundColor: isLight ? neutralColor : colorScheme.background,
      // tabBarTheme: TabBarTheme(
      //     labelColor: colorScheme.onSurface,
      //     unselectedLabelColor: colorScheme.onSurface,
      //     indicator: BoxDecoration(
      //         border: Border(
      //             bottom: BorderSide(color: colorScheme.primary, width: 2)))),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //     backgroundColor: colorScheme.secondaryContainer,
      //     foregroundColor: colorScheme.onSecondaryContainer),
      // navigationRailTheme: NavigationRailThemeData(
      //     backgroundColor: isLight ? neutralColor : colorScheme.surface,
      //     selectedIconTheme:
      //         IconThemeData(color: colorScheme.onSecondaryContainer),
      //     indicatorColor: colorScheme.secondaryContainer),
      // chipTheme: ChipThemeData(
      //     backgroundColor: isLight ? neutralColor : colorScheme.surface),
    );
  }

  ThemeData toThemeData() {
    final colorScheme = _schemeLight().toColorScheme(Brightness.light);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  ThemeData toThemeDataDark() {
    final colorScheme = _schemeDark().toColorScheme(Brightness.dark);
    return _base(colorScheme).copyWith(brightness: colorScheme.brightness);
  }

  @override
  ThemeExtension<CustomTheme> copyWith({
    Color? primaryColor,
    Color? tertiaryColor,
    Color? neutralColor,
  }) =>
      CustomTheme(
        primaryColor: primaryColor ?? this.primaryColor,
        tertiaryColor: tertiaryColor ?? this.tertiaryColor,
        neutralColor: neutralColor ?? this.neutralColor,
      );

  @override
  CustomTheme lerp(
    covariant ThemeExtension<CustomTheme>? other,
    double t,
  ) {
    if (other is! CustomTheme) return this;
    return CustomTheme(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      tertiaryColor: Color.lerp(tertiaryColor, other.tertiaryColor, t)!,
      neutralColor: Color.lerp(neutralColor, other.neutralColor, t)!,
    );
  }
}

extension on Scheme {
  ColorScheme toColorScheme(Brightness brightness) {
    return ColorScheme(
      primary: Color(primary),
      onPrimary: Color(onPrimary),
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
      secondary: Color(secondary),
      onSecondary: Color(onSecondary),
      secondaryContainer: Color(secondaryContainer),
      onSecondaryContainer: Color(onSecondaryContainer),
      tertiary: Color(tertiary),
      onTertiary: Color(onTertiary),
      tertiaryContainer: Color(tertiaryContainer),
      onTertiaryContainer: Color(onTertiaryContainer),
      error: Color(error),
      onError: Color(onError),
      errorContainer: Color(errorContainer),
      onErrorContainer: Color(onErrorContainer),
      outline: Color(outline),
      outlineVariant: Color(outlineVariant),
      background: Color(background),
      onBackground: Color(onBackground),
      surface: Color(surface),
      onSurface: Color(onSurface),
      surfaceVariant: Color(surfaceVariant),
      onSurfaceVariant: Color(onSurfaceVariant),
      inverseSurface: Color(inverseSurface),
      onInverseSurface: Color(inverseOnSurface),
      inversePrimary: Color(inversePrimary),
      shadow: Color(shadow),
      scrim: Color(scrim),
      surfaceTint: Color(primary),
      brightness: brightness,
    );
  }
}
