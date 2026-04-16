import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  final List<Color> colors;
  final Alignment begin;
  final Alignment end;

  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  final bool isLoading;
  final Widget? loader;

  final Color? disabledColor;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,

    this.colors = const [
      Color(0xFF4898AB),
      Color(0xFF90D46C),
    ],
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,

    this.borderRadius = 16,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(vertical: 14),

    this.width,
    this.height,

    this.isLoading = false,
    this.loader,

    this.disabledColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
            colors: colors,
            begin: begin,
            end: end,
          ),
          color: isDisabled
              ? (disabledColor ?? Colors.grey.shade400)
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: isLoading
              ? (loader ??
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ))
              : child,
        ),
      ),
    );
  }
}