import 'package:flutter/material.dart';

import '../presentation.dart';

class Toggle extends StatefulWidget {
  final bool isSelected;
  final bool isDisabled;
  final Color? selectedFillColor;
  final Color? unselectedFillColor;
  final Color? unselectedCircleColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final Color? disabledFillColor;
  final Color? disabledCircleColor;
  final void Function(bool toggleChecked) toggleFunction;

  const Toggle({
    Key? key,
    this.isSelected = false,
    this.isDisabled = false,
    this.selectedFillColor,
    this.unselectedFillColor,
    this.disabledFillColor,
    this.disabledCircleColor,
    this.unselectedCircleColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    required this.toggleFunction,
  }) : super(key: key);

  @override
  State<Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<Toggle>
    with SingleTickerProviderStateMixin {
  late Animation _circleAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 90));
    _circleAnimation = AlignmentTween(
            begin: widget.isSelected
                ? Alignment.centerRight
                : Alignment.centerLeft,
            end: widget.isSelected
                ? Alignment.centerLeft
                : Alignment.centerRight)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  Widget _buildToogleWithoutSelected() {
    final unselectedFillColor =
        widget.unselectedFillColor ?? const Color(0x0fffffff);
    final unselectedBorderColor =
        widget.unselectedBorderColor ?? const Color(0xFF000000);
    final unselectedCircleColor =
        widget.unselectedCircleColor ?? const Color(0x0fffffff);
    return BuildToogle(
        params: BuildToogleParams(
            backgroundColor: unselectedFillColor,
            borderColor: unselectedBorderColor,
            alignment: Alignment.centerLeft,
            circleColor: unselectedCircleColor,
            circleBorderColor: unselectedBorderColor));
  }

  Widget _buildToogleDisabled() {
    final disabledFillColor =
        widget.disabledFillColor ?? const Color(0xFFEEEEEE);
    final disabledCircleColor =
        widget.disabledCircleColor ?? const Color(0xFF424242);
    return BuildToogle(
        params: BuildToogleParams(
            backgroundColor: disabledFillColor,
            alignment: _circleAnimation.value,
            circleColor: disabledCircleColor));
  }

  Widget _buildToogleSelected() {
    final selectedFillColor = widget.selectedFillColor ??  Colors.greenAccent;// const Color(0x0fffffff);
    final unselectedCircleColor =
        widget.unselectedCircleColor ?? const Color(0xFF000000);
    final selectedBorderColor =
        widget.selectedBorderColor ?? const Color(0xFF000000);
    return BuildToogle(
        params: BuildToogleParams(
            backgroundColor: selectedFillColor,
            borderColor: selectedBorderColor,
            alignment: Alignment.centerRight,
            circleColor: unselectedCircleColor,
            circleBorderColor: selectedBorderColor));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      if (widget.isSelected) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
            onTap: () {
              if (widget.isDisabled) return;
              if (_animationController.isCompleted) {
                _animationController.reverse();
              } else {
                _animationController.forward();
              }

              setState(() {
                widget.toggleFunction(!widget.isSelected);
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isDisabled) ...[
                  _buildToogleDisabled()
                ] else if (widget.isSelected) ...[
                  _buildToogleSelected()
                ] else ...[
                  _buildToogleWithoutSelected()
                ]
              ],
            ));
      },
    );
  }
}
