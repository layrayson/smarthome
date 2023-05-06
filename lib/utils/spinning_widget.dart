import 'package:flutter/material.dart';

class SpinningWidget extends StatefulWidget {
  final Widget child;
  const SpinningWidget({super.key, required this.child});

  @override
  _SpinningWidgetState createState() => _SpinningWidgetState();
}

class _SpinningWidgetState extends State<SpinningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
