import 'package:flutter/material.dart';

class BidirectionalScroll extends StatefulWidget {
  final Widget child;
  final double scaleMax, scaleMin;

  BidirectionalScroll(
      {Key key, @required this.child, this.scaleMin = 1.0, this.scaleMax = 3.0})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _BidirectionalScrollState();
}

class _BidirectionalScrollState extends State<BidirectionalScroll> {
  double scale = 1.0, oldScale, xOffset = 0.0, yOffset = 0.0;
  Offset oldOffset;
  final parentKey = GlobalKey(), childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: parentKey,
      children: <Widget>[childWrapper, gestureHandler],
    );
  }

  Widget get childWrapper {
    return Center(
      child: Transform.translate(
        offset: Offset(xOffset, yOffset),
        child: Transform.scale(
          scale: scale,
          child: FittedBox(
            key: childKey,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget get gestureHandler {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails scaleDetails) {
        setState(() {
          oldOffset = scaleDetails.focalPoint;
          oldScale = 1.0;
        });
      },
      onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
        setState(() {
          // Set new scale value
          scale += scaleDetails.scale - oldScale;
          if (scale < widget.scaleMin) scale = widget.scaleMin;
          if (scale > widget.scaleMax) scale = widget.scaleMax;
          oldScale = scaleDetails.scale;
          // C stands for child, P stands for parent (the stack)
          // W stands for width, H stands for height
          final cw = childKey.currentContext.size.width * scale,
              ch = childKey.currentContext.size.height * scale,
              pw = parentKey.currentContext.size.width,
              ph = parentKey.currentContext.size.height;
          // Calculate pan amount since last call
          final panChange = scaleDetails.focalPoint - oldOffset;
          oldOffset = scaleDetails.focalPoint;
          // Fix things in the vertical direction
          if (ch <= ph)
            yOffset = 0;
          else {
            yOffset += panChange.dy;
            // Make yOffset within bounds of stack
            final maxOffset = (ch - ph) / 2;
            if (yOffset > maxOffset) yOffset = maxOffset;
            if (yOffset < -maxOffset) yOffset = -maxOffset;
          }
          // Fix things in the horizontal direction
          if (cw <= pw)
            xOffset = 0;
          else {
            xOffset += panChange.dx;
            // Make xOffset within bounds of stack
            final maxOffset = (cw - pw) / 2;
            if (xOffset > maxOffset) xOffset = maxOffset;
            if (xOffset < -maxOffset) xOffset = -maxOffset;
          }
        });
      },
    );
  }
}
