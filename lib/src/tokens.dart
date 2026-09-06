// SINH BỞI design/build_tokens.py — ĐỪNG SỬA TAY.
// Sửa design/tokens.json rồi chạy: python3 design/build_tokens.py
//
// Các màu gốc ở dạng OKLCH (bảng màu Tailwind v4 mà webapp đang dùng) đã
// được quy đổi sang sRGB ở đây, nên app và web ra đúng một màu.

import 'package:flutter/material.dart';

abstract final class AppColor {
  static const background = Color(0xFFFBF7EF);
  static const foreground = Color(0xFF1F2A2A);
  static const card = Color(0xFFFFFFFF);
  static const cardForeground = Color(0xFF1F2A2A);
  static const muted = Color(0xFFF1EADD);
  static const mutedForeground = Color(0xFF6F7573);
  static const primary = Color(0xFF0FA3A3);
  static const primaryForeground = Color(0xFFFFFFFF);
  static const border = Color(0xFFE9DFCD);
  static const input = Color(0xFFDCD0BA);
  static const ring = Color(0xFF0FA3A3);
  static const destructive = Color(0xFFEF4444);
  static const primaryDark = Color(0xFF0B7E7E);
  static const destructiveDark = Color(0xFFC62828);
  static const accent = Color(0xFFFFB800);
  static const accentForeground = Color(0xFF4A2C00);
  static const accentDark = Color(0xFFD99000);
  static const success = Color(0xFF00BC7D);  // oklch(69.6% 0.17 162.48)
  static const successStrong = Color(0xFF009966);  // oklch(59.6% 0.145 163.225)
  static const tierNew = Color(0xFFD4D4D8);  // oklch(87.1% 0.006 286.286)
  static const tierLearning = Color(0xFF00BCFF);  // oklch(74.6% 0.16 232.661)
  static const tierYoung = Color(0xFFA684FF);  // oklch(70.2% 0.183 293.541)
  static const tierMature = Color(0xFFFFB900);  // oklch(82.8% 0.189 84.429)
  static const tierStable = Color(0xFF00BC7D);  // oklch(69.6% 0.17 162.48)
}

/// Bảng màu thô của Tailwind v4, chỉ có ở phía Dart: webapp lấy thẳng từ
/// Tailwind nên không cần khai báo lại ở CSS. Dùng cho các trạng thái phụ
/// (nền thẻ đúng/sai, huy hiệu tier). Màu chính nằm ở AppColor.
abstract final class AppPalette {
  static const amber50 = Color(0xFFFFFBEB);  // oklch(98.7% 0.022 95.277)
  static const amber100 = Color(0xFFFEF3C6);  // oklch(96.2% 0.059 95.617)
  static const amber200 = Color(0xFFFEE685);  // oklch(92.4% 0.12 95.746)
  static const amber400 = Color(0xFFFFB900);  // oklch(82.8% 0.189 84.429)
  static const amber600 = Color(0xFFE17100);  // oklch(66.6% 0.179 58.318)
  static const amber700 = Color(0xFFBB4D00);  // oklch(55.5% 0.163 48.998)
  static const amber800 = Color(0xFF973C00);  // oklch(47.3% 0.137 46.201)
  static const emerald50 = Color(0xFFECFDF5);  // oklch(97.9% 0.021 166.113)
  static const emerald100 = Color(0xFFD0FAE5);  // oklch(95% 0.052 163.051)
  static const emerald200 = Color(0xFFA4F4CF);  // oklch(90.5% 0.093 164.15)
  static const emerald500 = Color(0xFF00BC7D);  // oklch(69.6% 0.17 162.48)
  static const emerald600 = Color(0xFF009966);  // oklch(59.6% 0.145 163.225)
  static const emerald700 = Color(0xFF007A55);  // oklch(50.8% 0.118 165.612)
  static const emerald800 = Color(0xFF006045);  // oklch(43.2% 0.095 166.913)
  static const indigo100 = Color(0xFFE0E7FF);  // oklch(93% 0.034 272.788)
  static const indigo700 = Color(0xFF432DD7);  // oklch(45.7% 0.24 277.023)
  static const red50 = Color(0xFFFEF2F2);  // oklch(97.1% 0.013 17.38)
  static const red200 = Color(0xFFFFC9C9);  // oklch(88.5% 0.062 18.334)
  static const red500 = Color(0xFFFB2C36);  // oklch(63.7% 0.237 25.331)
  static const red600 = Color(0xFFE7000B);  // oklch(57.7% 0.245 27.325)
  static const red700 = Color(0xFFC10007);  // oklch(50.5% 0.213 27.518)
  static const sky100 = Color(0xFFDFF2FE);  // oklch(95.1% 0.026 236.824)
  static const sky400 = Color(0xFF00BCFF);  // oklch(74.6% 0.16 232.661)
  static const sky700 = Color(0xFF0069A8);  // oklch(50% 0.134 242.749)
  static const violet100 = Color(0xFFEDE9FE);  // oklch(94.3% 0.029 294.588)
  static const violet400 = Color(0xFFA684FF);  // oklch(70.2% 0.183 293.541)
  static const violet700 = Color(0xFF7008E7);  // oklch(49.1% 0.27 292.581)
  static const zinc100 = Color(0xFFF4F4F5);  // oklch(96.7% 0.001 286.375)
  static const zinc200 = Color(0xFFE4E4E7);  // oklch(92% 0.004 286.32)
  static const zinc300 = Color(0xFFD4D4D8);  // oklch(87.1% 0.006 286.286)
  static const zinc600 = Color(0xFF52525C);  // oklch(44.2% 0.017 285.786)
}

abstract final class AppRadius {
  static const lg = 20.0;
  static const md = 16.0;
  static const sm = 12.0;
}

abstract final class AppFont {
  static const family = 'Nunito';
  static const xs = 12.0;
  static const xsHeight = 1.3333;
  static const sm = 14.0;
  static const smHeight = 1.4286;
  static const base = 16.0;
  static const baseHeight = 1.5;
  static const lg = 18.0;
  static const lgHeight = 1.5556;
  static const xl = 20.0;
  static const xlHeight = 1.4;
  static const xl2 = 24.0;
  static const xl2Height = 1.3333;
}

abstract final class AppSpace {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xl2 = 32.0;
  static const xl3 = 48.0;
  static const page = 16.0;
  static const pageWide = 24.0;
  static const card = 20.0;
  static const cardWide = 32.0;
  static const gap = 8.0;
  static const maxContentWidth = 896.0;
}
