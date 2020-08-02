import 'package:flutter/material.dart';
import 'package:todo_kch_app/screens/to_do_list/mask_overlay/overlay_mixin.dart';

class MaskOverlay extends StatefulWidget {
  final Widget child;
  final bool masked;
  final Function onMaskTap;

  const MaskOverlay(
      {Key key, @required this.child, this.masked, this.onMaskTap})
      : super(key: key);

  GlobalKey get globalKey {
    return child.key as GlobalKey;
  }

  @override
  MaskOverlayState createState() => MaskOverlayState();
}

class MaskOverlayState extends State<MaskOverlay> with MaskOverlayStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
