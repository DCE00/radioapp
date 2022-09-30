import 'package:flutter/material.dart';
import 'package:radioapp/constants/appcolors.dart';
import 'dart:math' show pi;
import 'package:radioapp/utilities/blopanim.dart';

class PlayButton extends StatefulWidget {
  final bool initialIsPlaying;
  final VoidCallback onPressed;
  final double iconSize;
  final double heightSize;
  final double widthSize;

  const PlayButton({
    Key? key,
    required this.iconSize,
    required this.onPressed,
    required this.heightSize,
    required this.widthSize,
    this.initialIsPlaying = false,
  }) : super(key: key);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);
  static const _iconAnimDuration = Duration(milliseconds: 700);

  late bool isPlaying = false;

  // rotation and scale animations
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _iconController;
  double _rotation = 0;
  double _scale = 0.85;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  @override
  void initState() {
    isPlaying = widget.initialIsPlaying;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    _iconController =
        AnimationController(vsync: this, duration: _iconAnimDuration);

    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);

    _scaleController.isCompleted
        ? _scaleController.reverse()
        : _scaleController.forward();

    isPlaying ? _iconController.forward() : _iconController.reverse();

    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.heightSize,
      width: widget.widthSize,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showWaves) ...[
              Blob(
                  color: const Color.fromARGB(249, 201, 106, 100),
                  scale: _scale,
                  rotation: _rotation),
              Blob(
                  color: const Color.fromARGB(255, 147, 70, 170),
                  scale: _scale,
                  rotation: _rotation * 2 - 30),
              Blob(
                  color: Colors.redAccent,
                  scale: _scale,
                  rotation: _rotation * 3 - 45),
            ],
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors().primaryColor,
              ),
              constraints: const BoxConstraints.expand(),
              child: AnimatedSwitcher(
                duration: _kToggleDuration,
                child: GestureDetector(
                  onTap: () {
                    _onToggle();
                  },
                  child: AnimatedIcon(
                    icon: AnimatedIcons.pause_play,
                    progress: _iconController,
                    size: widget.iconSize,
                    color: Colors.pink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    _iconController.dispose();
    super.dispose();
  }
}
