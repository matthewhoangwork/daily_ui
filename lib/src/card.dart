import 'package:flutter/material.dart';

import 'chunky.dart';
import 'tokens.dart';

/// Thẻ = tấm giấy dày: viền 2px + bo 16 + bề dày đặc 3px dưới đáy.
///
/// Thẻ KHÔNG lún khi bấm dù có onTap: nó là tấm giấy dày, không phải cái nút.
/// Bề dày ([chunkColor]) mặc định ăn theo màu viền — thẻ màu chỉ cần truyền
/// `borderColor` là đáy tự đậm theo, không phải nhớ thêm tham số.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.card),
    this.color,
    this.borderColor,
    this.chunkColor,
    this.onTap,
    this.onLongPress,
    this.enableInk = true,
    this.pixel = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? borderColor;
  final Color? chunkColor;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enableInk;
  final bool pixel;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColor.border;
    // pixel game: viền đen dày 3, góc vuông, bóng đen 4px, không bo
    if (pixel) {
      final pBorder = borderColor ?? Colors.black;
      return DecoratedBox(
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, 4), blurRadius: 0)],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color ?? AppColor.card,
            border: Border.all(color: pBorder, width: 3),
          ),
          child: Stack(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  splashFactory: enableInk ? null : NoSplash.splashFactory,
                  splashColor: enableInk ? null : Colors.transparent,
                  highlightColor: enableInk ? null : Colors.transparent,
                  hoverColor: enableInk ? null : Colors.transparent,
                  overlayColor: enableInk ? null : WidgetStateProperty.all(Colors.transparent),
                  child: Padding(padding: padding, child: child),
                ),
              ),
              // scanline nhẹ + highlight trên/dưới cho cảm giác CRT
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _PixelScanlinePainter(opacity: 0.05)),
                ),
              ),
              Positioned(top: 0, left: 0, right: 0, height: 2, child: Container(color: Colors.white.withValues(alpha: 0.22))),
              Positioned(bottom: 0, left: 0, right: 0, height: 2, child: Container(color: Colors.black.withValues(alpha: 0.12))),
            ],
          ),
        ),
      );
    }
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(chunkyRadius),
      side: BorderSide(color: border, width: chunkyBorderWidth),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(chunkyRadius),
        boxShadow: chunk(chunkColor ?? border, ChunkDepth.card),
      ),
      child: Material(
        color: color ?? AppColor.card,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          splashFactory: enableInk ? null : NoSplash.splashFactory,
          splashColor: enableInk ? null : Colors.transparent,
          highlightColor: enableInk ? null : Colors.transparent,
          hoverColor: enableInk ? null : Colors.transparent,
          overlayColor: enableInk ? null : WidgetStateProperty.all(Colors.transparent),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class _PixelScanlinePainter extends CustomPainter {
  _PixelScanlinePainter({this.opacity = 0.08});
  final double opacity;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: opacity);
    const gap = 3.0;
    for (double y = 0.5; y < size.height; y += gap) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Nhãn viên thuốc — chữ đậm trên nền màu nhạt.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.color, this.background, this.icon});

  final String label;
  final Color? color;
  final Color? background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColor.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? fg.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: AppFont.xs,
              fontWeight: FontWeight.w800,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
