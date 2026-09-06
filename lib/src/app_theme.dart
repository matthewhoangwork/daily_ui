import 'package:flutter/material.dart';

import 'tokens.dart';

/// ThemeData dựng từ token dùng chung với webapp.
///
/// Mọi màu và bo góc ở đây đều đến từ design/tokens.json — đừng viết
/// `Color(0x...)` hay `Radius.circular(12)` rải rác trong widget, vì đó chính
/// là cách giao diện app trôi dần khỏi web.
///
/// Đối chiếu với webapp: webapp/src/styles.css (biến CSS) và
/// webapp/src/components/ui (các biến thể nút, thẻ, ô nhập).
ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColor.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColor.primary,
    onPrimary: AppColor.primaryForeground,
    surface: AppColor.card,
    onSurface: AppColor.foreground,
    error: AppColor.destructive,
    outline: AppColor.border,
  );

  // Nunito, đúng font web đang chạy. Trước đây để null (font hệ thống) vì app
  // chưa bundle file nào; giờ 4 nấc đậm đã nằm trong assets/fonts (xem
  // pubspec.yaml), nên hai nền tảng ra đúng một mặt chữ.
  const fontFamily = AppFont.family;

  TextStyle t(double size, double height, FontWeight weight, Color color) =>
      TextStyle(
        fontSize: size,
        height: height,
        fontWeight: weight,
        color: color,
        // Web chỉ siết letter-spacing ở TIÊU ĐỀ (`h1–h4 { letter-spacing:
        // -0.015em }`), không siết chữ thường — Nunito tròn và rộng, siết cả
        // body sẽ làm đoạn văn dài đọc chật. Nên chỉ áp cho các nấc đậm.
        letterSpacing: weight.value >= FontWeight.w700.value ? -0.015 * size : 0,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColor.background,
    fontFamily: fontFamily,
    splashFactory: InkSparkle.splashFactory,

    // Nấc đậm khớp web: tiêu đề `font-extrabold` (800), nhãn/nút 800, chữ phụ
    // `font-medium` (500) chứ không phải 400 — Nunito ở 400 mảnh hơn Inter
    // nhiều nên chữ phụ để 400 sẽ nhìn nhợt.
    textTheme: TextTheme(
      titleLarge: t(AppFont.xl, AppFont.xlHeight, FontWeight.w800, AppColor.foreground),
      titleMedium: t(AppFont.lg, AppFont.lgHeight, FontWeight.w800, AppColor.foreground),
      titleSmall: t(AppFont.base, AppFont.baseHeight, FontWeight.w800, AppColor.foreground),
      bodyLarge: t(AppFont.base, AppFont.baseHeight, FontWeight.w400, AppColor.foreground),
      bodyMedium: t(AppFont.sm, AppFont.smHeight, FontWeight.w500, AppColor.foreground),
      bodySmall: t(AppFont.xs, AppFont.xsHeight, FontWeight.w500, AppColor.mutedForeground),
      labelLarge: t(AppFont.sm, AppFont.smHeight, FontWeight.w800, AppColor.foreground),
    ),

    // Viền 2px + bo 16 (rounded-2xl), khớp components/ui/card.jsx. Bề dày 3px
    // của `.card-solid` KHÔNG vẽ được ở đây (ShapeBorder không có bóng đặc) —
    // dùng AppCard ở widgets/ui.dart để có bề dày; `Card` trần chỉ còn dùng ở
    // vài chỗ phụ.
    cardTheme: CardThemeData(
      color: AppColor.card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColor.border, width: 2),
      ),
    ),

    // Nút của app là ChunkyButton (widgets/chunky.dart) — bề dày + cú lún
    // không diễn tả được bằng ButtonStyle. Ba theme dưới đây chỉ còn đỡ cho
    // các nút Material lọt lưới (dialog hệ thống, snackbar action), nên vẫn
    // chỉnh cho gần đúng chứ không bỏ trống.
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColor.primary,
        foregroundColor: AppColor.primaryForeground,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        textStyle: const TextStyle(fontSize: AppFont.sm, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.foreground,
        backgroundColor: AppColor.card,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: const BorderSide(color: AppColor.input, width: 2),
        textStyle: const TextStyle(fontSize: AppFont.sm, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.mutedForeground,
        minimumSize: const Size(0, 40),
        textStyle: const TextStyle(fontSize: AppFont.sm, fontWeight: FontWeight.w800),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      hintStyle: const TextStyle(color: AppColor.mutedForeground, fontSize: AppFont.base),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColor.input, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColor.input, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColor.ring, width: 2),
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColor.card,
      indicatorColor: AppColor.primary.withValues(alpha: 0.10),
      elevation: 0,
      height: 64,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (s) => TextStyle(
          fontSize: AppFont.xs,
          fontWeight: FontWeight.w800,
          color: s.contains(WidgetState.selected)
              ? AppColor.primary
              : AppColor.mutedForeground,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (s) => IconThemeData(
          size: 22,
          color: s.contains(WidgetState.selected)
              ? AppColor.primary
              : AppColor.mutedForeground,
        ),
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.background,
      foregroundColor: AppColor.foreground,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: AppFont.family,
        fontSize: AppFont.lg,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.015 * AppFont.lg,
        color: AppColor.foreground,
      ),
    ),

    dividerTheme: const DividerThemeData(color: AppColor.border, thickness: 2, space: 2),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColor.primary,
      linearTrackColor: AppColor.muted,
    ),
  );
}

/// Màu của một tier, tra theo `token` mà Worker trả về (xem
/// worker/src/lib/progress.js — TIERS). Client không tự quyết màu tier.
Color tierColor(String token) => switch (token) {
      'tierNew' => AppColor.tierNew,
      'tierLearning' => AppColor.tierLearning,
      'tierYoung' => AppColor.tierYoung,
      'tierMature' => AppColor.tierMature,
      'tierStable' => AppColor.tierStable,
      _ => AppColor.mutedForeground,
    };
