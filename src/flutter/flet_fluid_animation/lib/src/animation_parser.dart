import 'package:flutter/material.dart';
import 'package:flet/flet.dart';
import 'package:fluid_animations/fluid_animations.dart' as fluid;

ImplicitAnimationDetails? parseAnimation(dynamic value,
    [ImplicitAnimationDetails? defaultValue]) {
  if (value == null) {
    return defaultValue;
  } else if (value is bool && value == true) {
    return ImplicitAnimationDetails(
        duration: const Duration(milliseconds: 1000), curve: Curves.linear);
  } else if (value is int) {
    return ImplicitAnimationDetails(
        duration: parseDuration(value, const Duration())!,
        curve: Curves.linear);
  }
  return ImplicitAnimationDetails(
      duration: parseDuration(value["duration"], const Duration())!,
      curve: parseCurve(value["curve"], Curves.linear)!);
}

class ImplicitAnimationDetails {
  final Duration duration;
  final Curve curve;

  ImplicitAnimationDetails({required this.duration, required this.curve});
}

Curve? parseCurve(String? value, [Curve? defaultValue]) {
  switch (value?.toLowerCase()) {
    case "bouncein":
      return Curves.bounceIn;
    case "bounceinout":
      return Curves.bounceInOut;
    case "bounceout":
      return Curves.bounceOut;
    case "decelerate":
      return Curves.decelerate;
    case "ease":
      return Curves.ease;
    case "easein":
      return Curves.easeIn;
    case "easeinback":
      return Curves.easeInBack;
    case "easeincirc":
      return Curves.easeInCirc;
    case "easeincubic":
      return Curves.easeInCubic;
    case "easeinexpo":
      return Curves.easeInExpo;
    case "easeinout":
      return Curves.easeInOut;
    case "easeinoutback":
      return Curves.easeInOutBack;
    case "easeinoutcirc":
      return Curves.easeInOutCirc;
    case "easeinoutcubic":
      return Curves.easeInOutCubic;
    case "easeinoutcubicemphasized":
      return Curves.easeInOutCubicEmphasized;
    case "easeinoutexpo":
      return Curves.easeInOutExpo;
    case "easeinoutquad":
      return Curves.easeInOutQuad;
    case "easeinoutquart":
      return Curves.easeInOutQuart;
    case "easeinoutquint":
      return Curves.easeInOutQuint;
    case "easeinoutsine":
      return Curves.easeInOutSine;
    case "easeinquad":
      return Curves.easeInQuad;
    case "easeinquart":
      return Curves.easeInQuart;
    case "easeinquint":
      return Curves.easeInQuint;
    case "easeinsine":
      return Curves.easeInSine;
    case "easeintolinear":
      return Curves.easeInToLinear;
    case "easeout":
      return Curves.easeOut;
    case "easeoutback":
      return Curves.easeOutBack;
    case "easeoutcirc":
      return Curves.easeOutCirc;
    case "easeoutcubic":
      return Curves.easeOutCubic;
    case "easeoutexpo":
      return Curves.easeOutExpo;
    case "easeoutquad":
      return Curves.easeOutQuad;
    case "easeoutquart":
      return Curves.easeOutQuart;
    case "easeoutquint":
      return Curves.easeOutQuint;
    case "easeoutsine":
      return Curves.easeOutSine;
    case "elasticin":
      return Curves.elasticIn;
    case "elasticinout":
      return Curves.elasticInOut;
    case "elasticout":
      return Curves.elasticOut;
    case "fastlineartosloweasein":
      return Curves.fastLinearToSlowEaseIn;
    case "fastoutslowin":
      return Curves.fastOutSlowIn;
    case "lineartoeaseout":
      return Curves.linearToEaseOut;
    case "slowmiddle":
      return Curves.slowMiddle;
    default:
      return defaultValue;
  }
}

AnimationStyle? parseAnimationStyle(dynamic value,
    [AnimationStyle? defaultValue]) {
  if (value == null) return defaultValue;

  return AnimationStyle(
      curve: parseCurve(value["curve"]),
      reverseCurve: parseCurve(value["reverse_curve"]),
      duration: parseDuration(value["duration"]),
      reverseDuration: parseDuration(value["reverse_duration"]));
}

// FluidSpring parser
fluid.FluidSpring parseFluidSpring(dynamic value,
    [fluid.FluidSpring? defaultValue]) {
  if (value == null) {
    return defaultValue ??
        fluid.FluidSpring.withDamping(dampingFraction: 0.5, duration: 0.5);
  }

  return fluid.FluidSpring.withDamping(
    dampingFraction: value["dampingFraction"] ?? 0.5,
    duration: value["duration"] ?? 0.5,
  );
}

// Parse CurvedKeyframe
fluid.CurvedKeyframe<double> parseCurvedKeyframe(dynamic value) {
  if (value == null) {
    return const fluid.CurvedKeyframe<double>(
        value: 0, duration: 0.5, curve: Curves.linear);
  }

  return fluid.CurvedKeyframe<double>(
    value: value["value"]?.toDouble() ?? 0.0,
    duration: value["duration"]?.toDouble() ?? 0.5,
    curve: parseCurve(value["curve"], Curves.linear)!,
  );
}

// Parse SpringKeyframe
fluid.SpringKeyframe<double> parseSpringKeyframe(dynamic value) {
  if (value == null) {
    return fluid.SpringKeyframe<double>(
      value: 0,
      duration: 0.5,
      spring:
          fluid.FluidSpring.withDamping(dampingFraction: 0.5, duration: 0.5),
    );
  }

  return fluid.SpringKeyframe<double>(
    value: value["value"]?.toDouble() ?? 0.0,
    duration: value["duration"]?.toDouble() ?? 0.5,
    spring: parseFluidSpring(value["spring"]),
    velocity: value["velocity"]?.toDouble(),
  );
}

// Parse keyframe list (mixed CurvedKeyframe and SpringKeyframe)
List<fluid.Keyframe<double>> parseKeyframes(List<dynamic>? keyframesList) {
  if (keyframesList == null || keyframesList.isEmpty) {
    return [
      const fluid.CurvedKeyframe<double>(
          value: 0, duration: 0.5, curve: Curves.linear)
    ];
  }

  List<fluid.Keyframe<double>> result = [];

  for (var keyframe in keyframesList) {
    String type = keyframe["type"] ?? "curved";

    if (type == "spring") {
      result.add(parseSpringKeyframe(keyframe));
    } else {
      result.add(parseCurvedKeyframe(keyframe));
    }
  }

  return result;
}

extension AnimationParsers on Control {
  ImplicitAnimationDetails? getAnimation(String propertyName,
      [ImplicitAnimationDetails? defaultValue]) {
    return parseAnimation(get(propertyName), defaultValue);
  }

  Curve? getCurve(String propertyName, [Curve? defaultValue]) {
    return parseCurve(get(propertyName), defaultValue);
  }

  AnimationStyle? getAnimationStyle(String propertyName,
      [AnimationStyle? defaultValue]) {
    return parseAnimationStyle(get(propertyName), defaultValue);
  }
}

extension FluidAnimationParsers on Control {
  double? getStartingValue(String propertyName, [double defaultValue = 0.0]) {
    var value = get(propertyName);
    return value?.toDouble() ?? defaultValue;
  }

  List<fluid.Keyframe<double>> getKeyframes(String propertyName) {
    var keyframes = get(propertyName);
    return parseKeyframes(keyframes);
  }

  fluid.FluidSpring? getFluidSpring(String propertyName,
      [fluid.FluidSpring? defaultValue]) {
    return parseFluidSpring(get(propertyName), defaultValue);
  }
}
