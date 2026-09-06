import 'package:flutter/material.dart';

import 'haptics.dart';
import 'tokens.dart';

/// Ngôn ngữ hình thức "khối dày" — bản Flutter của các lớp `.chunky`,
/// `.card-solid`, `.track` trong webapp/src/styles.css.
///
/// Một ý duy nhất: **mọi thứ bấm được đều là một KHỐI có bề dày**. Bề dày là
/// một vệt đặc (`BoxShadow` với `blurRadius: 0`) màu đậm hơn nền, nằm ngay
/// dưới khối; bấm vào thì khối tụt xuống đúng chừng ấy pixel và vệt biến mất,
/// như một phím bấm thật.
///
/// Vì sao không dùng `elevation` của Material: elevation vẽ bóng MỜ toả ra
/// bốn phía (ánh sáng), còn đây là bề DÀY của vật (hình khối). Đổi sang bóng
/// mờ là mất hẳn cảm giác bấm được — xem ghi chú `$doc_dark` trong
/// design/tokens.json.
///
/// Bề dày không chiếm chỗ trong layout (BoxShadow không tính vào kích thước),
/// đúng như box-shadow ở web, nên đặt nút vào Row/Column không phải chừa gì.

/// Độ dày chuẩn, khớp `--chunk-depth` ở styles.css.
abstract final class ChunkDepth {
  /// `.chunky` — nút và mọi thứ bấm được.
  static const button = 4.0;

  /// `.card-solid` — thẻ tĩnh, dày vừa phải, không lún.
  static const card = 3.0;

  /// `.chunky-sm` — hàng/thẻ bấm được trong danh sách.
  static const row = 2.0;
}

/// Bề dày dưới đáy một khối: một vệt đặc, không phải bóng mờ.
List<BoxShadow> chunk(Color color, [double depth = ChunkDepth.button]) => [
      BoxShadow(color: color, offset: Offset(0, depth), blurRadius: 0, spreadRadius: 0),
    ];

/// Viền của mọi thẻ/nút ở giao diện này. Web đã đổi 1px → 2px
/// (`border-2` trong components/ui/card.jsx, button.jsx).
const chunkyBorderWidth = 2.0;

/// Bo góc dùng chung cho thẻ và nút — web dùng `rounded-2xl` cho thẻ và
/// `rounded-md` cho nút, cả hai đều ra 16px, tức AppRadius.md.
double get chunkyRadius => AppRadius.md;

/// Vùng chạm tối thiểu (Apple HIG 44pt, Material 48dp — lấy 44 cho khỏi phá
/// nhịp của hàng danh sách). Không phải chiều cao VẼ RA: nút vẫn nhỏ như cũ,
/// chỉ vùng nhận ngón tay là nở ra cho đủ. Xem `_ChunkyButtonState.build`.
const kMinTouchTarget = 44.0;

// ---------------------------------------------------------------------------
// Nút
// ---------------------------------------------------------------------------

/// Khớp `variant` của webapp/src/components/ui/button.jsx.
enum ChunkyVariant { primary, destructive, outline, success, accent, ghost }

/// Khớp `size` của button.jsx: default h-11, sm h-9, icon size-10.
enum ChunkySize { normal, small, icon }

class _VariantSkin {
  const _VariantSkin({
    required this.background,
    required this.foreground,
    this.chunkColor,
    this.borderColor,
  });

  final Color background;
  final Color foreground;
  final Color? chunkColor; // null = phẳng, không lún (ghost)
  final Color? borderColor;
}

_VariantSkin _skinOf(ChunkyVariant v) => switch (v) {
      ChunkyVariant.primary => const _VariantSkin(
          background: AppColor.primary,
          foreground: AppColor.primaryForeground,
          chunkColor: AppColor.primaryDark,
        ),
      ChunkyVariant.destructive => const _VariantSkin(
          background: AppColor.destructive,
          foreground: Colors.white,
          chunkColor: AppColor.destructiveDark,
        ),
      ChunkyVariant.outline => const _VariantSkin(
          background: AppColor.card,
          foreground: AppColor.foreground,
          chunkColor: AppColor.border,
          borderColor: AppColor.input,
        ),
      ChunkyVariant.success => const _VariantSkin(
          background: AppColor.success,
          foreground: Colors.white,
          chunkColor: AppColor.successStrong,
        ),
      ChunkyVariant.accent => const _VariantSkin(
          background: AppColor.accent,
          foreground: AppColor.accentForeground,
          chunkColor: AppColor.accentDark,
        ),
      ChunkyVariant.ghost => const _VariantSkin(
          background: Colors.transparent,
          foreground: AppColor.mutedForeground,
        ),
    };

/// Nút khối. Thay cho `FilledButton`/`OutlinedButton` của Material ở toàn bộ
/// app — không phải vì Material xấu, mà vì `ButtonStyle` không diễn tả được
/// bề dày đặc + cú lún, và nửa nạc nửa mỡ thì hai loại nút cạnh nhau sẽ lệch.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.onPressed,
    this.label,
    this.icon,
    this.child,
    this.variant = ChunkyVariant.primary,
    this.size = ChunkySize.normal,
    this.expand = false,
  }) : assert(label != null || child != null || icon != null,
            'Nút phải có label, child hoặc icon');

  /// null = vô hiệu hoá (mờ đi, không bấm được), khớp `disabled:opacity-50`.
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;

  /// Dùng khi nội dung không phải chữ thuần (vòng quay lúc đang gửi...).
  final Widget? child;

  final ChunkyVariant variant;
  final ChunkySize size;

  /// Giãn hết bề ngang — thay cho `SizedBox(width: double.infinity)` bọc ngoài.
  final bool expand;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    final skin = _skinOf(widget.variant);
    final depth = skin.chunkColor == null ? 0.0 : ChunkDepth.button;
    final pressed = _down && _enabled;

    final (height, padH, fontSize) = switch (widget.size) {
      ChunkySize.normal => (44.0, 20.0, AppFont.sm),
      ChunkySize.small => (36.0, 14.0, AppFont.xs),
      ChunkySize.icon => (40.0, 0.0, AppFont.sm),
    };

    final content = <Widget>[
      if (widget.icon != null)
        Icon(widget.icon, size: widget.size == ChunkySize.small ? 15 : 18, color: skin.foreground),
      if (widget.child != null)
        widget.child!
      else if (widget.label != null)
        Flexible(
          child: Text(
            widget.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              // font-extrabold — nhãn nút là nấc đậm nhất của giao diện.
              fontWeight: FontWeight.w800,
              color: skin.foreground,
              letterSpacing: -0.1,
            ),
          ),
        ),
    ];

    Widget box = Container(
      height: widget.size == ChunkySize.icon ? height : null,
      constraints: widget.size == ChunkySize.icon
          ? BoxConstraints.tight(Size(height, height))
          : BoxConstraints(minHeight: height),
      padding: EdgeInsets.symmetric(horizontal: padH),
      decoration: BoxDecoration(
        color: skin.background,
        borderRadius: BorderRadius.circular(chunkyRadius),
        border: skin.borderColor == null
            ? null
            : Border.all(color: skin.borderColor!, width: chunkyBorderWidth),
        // Lúc lún thì bề dày biến mất — nếu chỉ dịch khối xuống mà giữ vệt,
        // nó trông như cả cái nút trượt đi chứ không phải bị ấn xuống.
        boxShadow: (pressed || skin.chunkColor == null) ? null : chunk(skin.chunkColor!, depth),
      ),
      child: Row(
        mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8, // gap-2
        children: content,
      ),
    );

    if (pressed) box = Transform.translate(offset: Offset(0, depth), child: box);
    if (!_enabled) box = Opacity(opacity: 0.5, child: box);
    if (widget.expand) box = SizedBox(width: double.infinity, child: box);

    // Nút nhỏ chỉ cao 36–40px, dưới mức 44pt mà HIG đòi. Không kéo cao hình
    // vẽ (hàng danh sách sẽ phình ra), mà chèn một vành trong suốt quanh nó:
    // mắt thấy nút nhỏ, ngón tay chạm vào vùng đủ lớn.
    final grow = (kMinTouchTarget - height) / 2;
    if (grow > 0) {
      box = Padding(padding: EdgeInsets.symmetric(vertical: grow), child: box);
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled
            ? (_) {
                // Ngôn ngữ hình thức là "phím bấm thật" — thiếu cú rung thì
                // chỉ có mắt tin, tay thì không. Rung ở onTapDown chứ không
                // onTap: phải trùng khoảnh khắc khối lún xuống.
                AppHaptics.tap();
                setState(() => _down = true);
              }
            : null,
        onTapUp: _enabled ? (_) => setState(() => _down = false) : null,
        onTapCancel: _enabled ? () => setState(() => _down = false) : null,
        onTap: widget.onPressed,
        child: box,
      ),
    );
  }
}

/// Nút chữ trần (`variant="link"`/`ghost` ở web) — không khối, không bề dày.
/// Giữ riêng vì nó là thứ duy nhất trong bộ nút KHÔNG phải một khối.
class ChunkyTextButton extends StatelessWidget {
  const ChunkyTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.color = AppColor.mutedForeground,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 16, color: color),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 40),
        textStyle: const TextStyle(fontSize: AppFont.sm, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Thanh tiến độ kiểu game (`.track` + `.track-fill` ở styles.css)
// ---------------------------------------------------------------------------

/// Rãnh đậm, thanh chạy bo tròn có vệt sáng trên đỉnh để nhìn như khối nhựa
/// bóng chứ không phải một hình chữ nhật đặc.
class ChunkyTrack extends StatelessWidget {
  const ChunkyTrack({
    super.key,
    required this.value,
    this.secondaryValue,
    this.height = 12,
    this.color = AppColor.primary,
    this.secondaryColor = AppColor.tierMature,
    this.animate = true,
    this.semanticLabel,
  });

  final double value; // 0..1
  final double? secondaryValue; // cumulative, 0..1
  final double height;
  final Color color;
  final Color secondaryColor;
  final bool animate;

  /// Đọc lên cho VoiceOver — thanh tiến độ là hình, không có chữ nào để đọc,
  /// nên không khai ở đây thì người dùng trình đọc màn hình mất trắng chỉ số.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final v = value.clamp(0.0, 1.0);
    final secondary = (secondaryValue ?? v).clamp(v, 1.0);
    final duration = (!animate || MediaQuery.disableAnimationsOf(context))
        ? Duration.zero
        : const Duration(milliseconds: 600);
    return Semantics(
      label: semanticLabel,
      value: '${(v * 100).round()}%',
      child: Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColor.muted,
        borderRadius: BorderRadius.circular(999),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black.withValues(alpha: 0.12), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          AnimatedFractionallySizedBox(
            key: const ValueKey('chunky-track-secondary'),
            duration: duration,
            curve: Curves.easeOutCubic,
            widthFactor: secondary,
            heightFactor: 1,
            alignment: Alignment.centerLeft,
            child: ColoredBox(color: secondaryColor),
          ),
          AnimatedFractionallySizedBox(
            key: const ValueKey('chunky-track-primary'),
            duration: duration,
            curve: Curves.easeOutCubic,
            widthFactor: v,
            heightFactor: 1,
            alignment: Alignment.centerLeft,
            child: ColoredBox(color: color),
          ),
          if (height >= 8)
            Positioned(
              top: 2,
              left: 4,
              right: 4,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      ),
      ),
    );
  }
}
