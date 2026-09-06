import 'package:flutter/services.dart';

/// Ponytail wrapper quanh [HapticFeedback] — một chỗ để mock/test và để đổi
/// cảm giác rung sau này mà không rải `HapticFeedback` khắp nơi.
///
/// Spec: `docs/superpowers/specs/2026-09-01-duolingo-haptics-sfx-design.md`
/// Luôn BẬT (B), không toggle Settings.
abstract final class AppHaptics {
  static void tap() {
    try {
      HapticFeedback.selectionClick();
    } catch (_) {}
  }

  static void light() {
    try {
      HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static void medium() {
    try {
      HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static void heavy() {
    try {
      HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  /// Đúng → rung nhẹ
  static void correct() => light();

  /// Sai → rung mạnh (cảnh báo)
  static void wrong() => heavy();

  /// Vào màn bài tập → rung nhẹ đồng bộ với SFX entrance
  static void enter() => light();
}
