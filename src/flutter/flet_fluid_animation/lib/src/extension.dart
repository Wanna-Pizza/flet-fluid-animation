import 'package:flet/flet.dart';
import 'package:flutter/cupertino.dart';

import 'flet_fluid_animation.dart';

class Extension extends FletExtension {
  @override
  Widget? createWidget(Key? key, Control control) {
    switch (control.type) {
      case "FluidAnimation":
        return FletFluidAnimationControl(control: control);
      default:
        return null;
    }
  }
}
