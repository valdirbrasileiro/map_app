import 'package:flutter/material.dart';

class BuildToogleParams {
  final Color backgroundColor;
  final Color? borderColor;
  final AlignmentGeometry alignment;
  final Color circleColor;
  final Color? circleBorderColor;
  BuildToogleParams({
    required this.backgroundColor,
    this.borderColor,
    required this.alignment,
    required this.circleColor,
    this.circleBorderColor,
  });
}

class BuildToogle extends StatelessWidget {
  final BuildToogleParams params;

  const BuildToogle({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0,
      height: 28.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: params.backgroundColor,
        border: params.borderColor != null
            ? Border.all(color: params.borderColor!)
            : null,
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 2.0, bottom: 2.0, right: 3.0, left: 3.0),
        child: Container(
          alignment: params.alignment,
          child: Container(
            width: 20.0,
            height: 20.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: params.circleColor,
                border: params.circleBorderColor != null
                    ? Border.all(color: params.circleBorderColor!)
                    : null),
          ),
        ),
      ),
    );
  }
}
