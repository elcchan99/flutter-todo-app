import 'package:flutter/material.dart';
import 'package:todo_kch_app/screens/to_do_list/mask_overlay/mask_overlay.dart';

mixin MaskOverlayStateMixin on State<MaskOverlay> {
  OverlayEntry overlayMask;

  bool _masked = false;

  @override
  void initState() {
    print("MaskOverlayStateMixin initState()");
    _masked = widget.masked;
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      print(duration);
      _masked ? mask() : unmask();
    });
    super.initState();
  }

  void mask() {
    if (overlayMask == null) {
      print("mask");
      final RenderBox renderBox =
          widget.globalKey.currentContext.findRenderObject();
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);
      overlayMask = overlayMask ?? buildMask(context, size, position);
      print("MaskOverlayStateMixin before insert");
      Overlay.of(context).insert(overlayMask);
      print("MaskOverlayStateMixin after insert");
    }
  }

  void unmask() {
    if (overlayMask != null) {
      print("unmask");
      print("MaskOverlayStateMixin remove overlay");
      overlayMask.remove();
      overlayMask = null;
    }
  }

  void setMask() {
    if (!_masked) {
      print("setMask");
      setState(() {
        _masked = true;
      });
    }
  }

  void setUnmask() {
    if (_masked) {
      print("setUmask");
      setState(() {
        _masked = false;
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    print("MaskOverlayStateMixin didUpdateWidget()");
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _masked ? mask() : unmask();
    });
  }

  onExit() {
    if (widget.onMaskTap != null) {
      widget.onMaskTap();
    }
  }

  OverlayEntry buildMask(context, Size size, Offset position) {
    return OverlayEntry(
      builder: (context) {
        return Stack(children: [
          Positioned(
              top: 0,
              height: position.dy,
              width: size.width,
              child: GestureDetector(
                  onTap: onExit,
                  child: Container(color: Colors.black.withOpacity(0.3)))),
          Positioned(
              top: position.dy + size.height,
              bottom: 0,
              width: size.width,
              child: GestureDetector(
                  onTap: onExit,
                  child: Container(color: Colors.black.withOpacity(0.3)))),
        ]);
      },
    );
  }

  @override
  void dispose() {
    print("MaskOverlayStateMixin dispose()");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unmask();
    });
    super.dispose();
  }
}
