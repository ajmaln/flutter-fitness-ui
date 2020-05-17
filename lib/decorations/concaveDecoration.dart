import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class CornerDecoration extends Decoration {
  final bool fillLeft;
  final bool fillTop;
  final bool fillRight;
  final bool fillBottom;
  final double strokeWidth;
  final Color strokeColor;
  final EdgeInsets insets;
  final double position;
  final double cornerSide;

  CornerDecoration({
    this.fillLeft = false,
    this.fillTop = false,
    this.fillRight = false,
    this.fillBottom = false,
    this.strokeWidth = 3,
    @required this.strokeColor,
    EdgeInsets insets,
    this.position = 0.5,
    this.cornerSide = 16,
  }) : insets = insets ?? EdgeInsets.all(strokeWidth);

  @override
  BoxPainter createBoxPainter([onChanged]) => 
    _CornerBoxPainter(fillLeft, fillTop, fillRight, fillBottom, strokeWidth, strokeColor, insets, position, cornerSide);

  @override
  EdgeInsetsGeometry get padding => insets;
}

class _CornerBoxPainter extends BoxPainter {
  final bool fillLeft;
  final bool fillTop;
  final bool fillRight;
  final bool fillBottom;
  final double strokeWidth;
  final EdgeInsets insets;
  final double position;
  final double cornerSide;
  Paint _p;
  Path _path;
  Rect _rect;

  _CornerBoxPainter(this.fillLeft, this.fillTop, this.fillRight, this.fillBottom, this.strokeWidth, strokeColor, this.insets, this.position, this.cornerSide) {
    _p = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    var baseRect = offset & configuration.size;
    if (baseRect != _rect) {
      print('new size: $baseRect');
      _rect = baseRect;

      var a = baseRect.deflate(strokeWidth / 2);
      var b = insets.deflateRect(baseRect).inflate(strokeWidth / 2);
      var rect = Rect.lerp(a, b, position);

      _path = Path()
        ..moveTo(rect.topLeft.dx, rect.topLeft.dy);

      var horizontalOffsets = [
        Offset(cornerSide, 0), Offset(rect.width - 2 * cornerSide, 0), Offset(rect.width, 0),
      ];
      var verticalOffsets = [
        Offset(0, cornerSide), Offset(0, rect.height - 2 * cornerSide), Offset(0, rect.height),
      ];

      _buildPathSide(fillTop, horizontalOffsets, false);
      _buildPathSide(fillRight, verticalOffsets, false);
      _buildPathSide(fillBottom, horizontalOffsets, true);
      _buildPathSide(fillLeft, verticalOffsets, true);
    }
    canvas.drawPath(_path, _p);
  }

  void _buildPathSide(bool fillSide, List<Offset> offsets, bool reverse) {
    if (reverse) offsets = offsets.map((o) => -o).toList();
    if (fillSide) _path
      ..relativeLineTo(offsets[2].dx, offsets[2].dy);
    else _path
      ..relativeLineTo(offsets[0].dx, offsets[0].dy)
      ..relativeMoveTo(offsets[1].dx, offsets[1].dy)
      ..relativeLineTo(offsets[0].dx, offsets[0].dy);
  }
}

class ConcaveDecoration extends Decoration {
  final ShapeBorder shape;
  final double depth;
  final List<Color> colors;
  final double opacity;

  ConcaveDecoration({
    @required this.shape,
    @required this.depth,
    this.colors = const [Colors.black87, Colors.white],
    this.opacity = 1.0,
  }) : assert(shape != null), assert(colors == null || colors.length == 2);

  @override
  BoxPainter createBoxPainter([onChanged]) => _ConcaveDecorationPainter(shape, depth, colors, opacity);

  @override
  EdgeInsetsGeometry get padding => shape.dimensions;

  @override
  Decoration lerpFrom(Decoration a, double t) {
    if (a is ConcaveDecoration) {
      t = Curves.easeInOut.transform(t);
      return ConcaveDecoration(
        shape: ShapeBorder.lerp(a.shape, shape, t),
        depth: ui.lerpDouble(a.depth, depth, t),
        colors: [
          Color.lerp(a.colors[0], colors[0], t),
          Color.lerp(a.colors[1], colors[1], t),
        ],
        opacity: ui.lerpDouble(a.opacity, opacity, t),
      );
    }
    return null;
  }
}

class _ConcaveDecorationPainter extends BoxPainter {
  ShapeBorder shape;
  double depth;
  List<Color> colors;
  double opacity;

  _ConcaveDecorationPainter(this.shape, this.depth, this.colors, this.opacity) {
    if (depth > 0) {
      colors = [
        colors[1],
        colors[0],
      ];
    } else {
      depth = -depth;
    }
    colors = [
      colors[0].withOpacity(opacity),
      colors[1].withOpacity(opacity),
    ];
  }

  @override
  void paint(ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final shapePath = shape.getOuterPath(offset & configuration.size);
    final rect = shapePath.getBounds();

    final delta = 16 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depth * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, depth);
    final clipSize = rect.size.aspectRatio > 1? Size(rect.width, rect.height / 2) : Size(rect.width / 2, rect.height);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect = alignment.inscribe(Size.square(rect.longestSide), rect);
      paint..shader = ui.Gradient.linear(shaderRect.topLeft, shaderRect.bottomRight, colors, stops);

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}