import 'package:flutter/material.dart';

enum DeevTabIndicatorStyle { circle, rectangle }

class DeevTabIndicator extends Decoration {
  final double indicatorHeight, width, yOffset, radius;
  final Color indicatorColor;
  final DeevTabIndicatorStyle indicatorStyle;

  const DeevTabIndicator(
      {this.indicatorHeight = 2,
      required this.indicatorColor,
      this.indicatorStyle = DeevTabIndicatorStyle.circle,
      this.width = 20,
      this.yOffset = 28,
      this.radius = 4});

  @override
  _DeevTabIndicatorPainter createBoxPainter([VoidCallback? onChanged]) {
    return _DeevTabIndicatorPainter(this, onChanged);
  }
}

class _DeevTabIndicatorPainter extends BoxPainter {
  final DeevTabIndicator decoration;

  _DeevTabIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    if (decoration.indicatorStyle == DeevTabIndicatorStyle.circle) {
      final Paint paint = Paint()
        ..color = decoration.indicatorColor
        ..style = PaintingStyle.fill;
      final Offset circleOffset = offset +
          Offset(configuration.size!.width / 2 - (decoration.radius / 20),
              decoration.yOffset);
      canvas.drawCircle(circleOffset, decoration.radius, paint);
    } else if (decoration.indicatorStyle == DeevTabIndicatorStyle.rectangle) {
      Rect rect = Offset(
            offset.dx + configuration.size!.width / 2 - (decoration.width / 2),
            decoration.yOffset,
          ) &
          Size(decoration.width, decoration.indicatorHeight);

      RRect radiusRectangle =
          RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius));
      final Paint paint = Paint()
        ..color = decoration.indicatorColor
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        radiusRectangle,
        paint,
      );
    }
  }
}
