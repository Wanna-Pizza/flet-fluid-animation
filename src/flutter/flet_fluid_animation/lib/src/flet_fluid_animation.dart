import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:fluid_animations/fluid_animations.dart';
import 'animation_parser.dart';

class FletFluidAnimationControl extends StatefulWidget {
  final Control control;

  const FletFluidAnimationControl({
    super.key,
    required this.control,
  });

  @override
  State<FletFluidAnimationControl> createState() =>
      _FletFluidAnimationControlState();
}

class _FletFluidAnimationControlState extends State<FletFluidAnimationControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFirstBuild = true;
  String _lastAnimationProperty = "";
  double _totalDuration = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    // Get the starting value and keyframes from the control
    double startingValue =
        widget.control.getStartingValue("starting_value", 0.0) ?? 0.0;
    List<Keyframe<double>> keyframes = widget.control.getKeyframes("keyframes");

    // Calculate total duration based on keyframes total duration
    _totalDuration = 0;
    for (var keyframe in keyframes) {
      _totalDuration += keyframe.duration;
    }

    // Debug print to see actual duration
    debugPrint("Total animation duration: ${_totalDuration} seconds");

    // Create the animation controller with the total duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_totalDuration * 1000).round()),
    );

    // Create the fluid animation using keyframes and our controller
    _animation = KeyframeAnimation<double>(
      startingValue: startingValue,
      keyframes: keyframes,
    ).animate(_controller);

    // Get animation property (transform type)
    _lastAnimationProperty =
        widget.control.get("animation_property") ?? "translateX";

    // Start the animation with autoplay
    _controller.reset();
    _controller.forward();
  }

  @override
  void didUpdateWidget(FletFluidAnimationControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if we need to update the animation
    if (oldWidget.control != widget.control) {
      _controller.dispose();
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var content = widget.control.buildWidget("content");

    // If it's the first build and we have no content, show a placeholder
    if (_isFirstBuild && content == null) {
      _isFirstBuild = false;
      return const SizedBox();
    }
    _isFirstBuild = false;

    // Create combined widget with content and duration info
    Widget combinedContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content ?? const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Duration: ${_totalDuration.toStringAsFixed(2)}s",
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );

    // Create the animated widget
    Widget animatedWidget = AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return _buildAnimatedWidget(
            child, _animation.value, _lastAnimationProperty);
      },
      child: combinedContent,
    );

    return ConstrainedControl(
      control: widget.control,
      child: animatedWidget,
    );
  }

  Widget _buildAnimatedWidget(
      Widget? child, double value, String propertyType) {
    switch (propertyType.toLowerCase()) {
      case "translatex":
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
      case "translatey":
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      case "scale":
        return Transform.scale(
          scale: value,
          child: child,
        );
      case "rotate":
        return Transform.rotate(
          angle: value * (3.14159265359 / 180), // Convert degrees to radians
          child: child,
        );
      case "opacity":
        // Ensure opacity is between 0.0 and 1.0
        final opacity = value.clamp(0.0, 1.0);
        return Opacity(
          opacity: opacity,
          child: child,
        );
      default:
        // Default to translateX if unknown property type
        return Transform.translate(
          offset: Offset(value, 0),
          child: child,
        );
    }
  }
}
