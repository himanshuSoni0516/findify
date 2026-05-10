import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.maxLines = 1,
    this.obscureText = false,
    this.inputFormatters,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.autofocus = false,
  });

  final String? label;
  final String? hint;
  final TextEditingController controller;
  final IconData? prefixIcon;

  /// Custom suffix widget — pass your own or leave null.
  /// For password fields use [obscureText] = true instead; the toggle is
  /// handled automatically.
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  /// 1 = single-line, >1 = multiline (obscureText is ignored when >1).
  final int maxLines;

  /// Adds an automatic visibility-toggle suffix icon.
  final bool obscureText;

  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool autofocus;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _hidden;

  // Icon area is 40px wide, vertically centered in the field
  static const _iconConstraints = BoxConstraints(minWidth: 40, minHeight: 40);

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final hasPrefixIcon = widget.prefixIcon != null;
    final hasSuffixIcon = widget.obscureText || widget.suffixIcon != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────────────
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.label!,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
          ),

        // ── Field ──────────────────────────────────────────────────────────
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          obscureText: widget.obscureText && _hidden,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          autofocus: widget.autofocus,
          decoration: InputDecoration(
            hintText: widget.hint,

            // ── Prefix ───────────────────────────────────────────────────
            prefixIcon: hasPrefixIcon
                ? Icon(widget.prefixIcon, size: 20)
                : null,
            // Shrinks the icon box so contentPadding takes effect on the left
            prefixIconConstraints: hasPrefixIcon ? _iconConstraints : null,

            // ── Suffix ───────────────────────────────────────────────────
            suffixIcon: _buildSuffix(),
            // Shrinks the icon box so contentPadding takes effect on the right
            suffixIconConstraints: hasSuffixIcon ? _iconConstraints : null,
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffix() {
    if (widget.obscureText) {
      return GestureDetector(
        onTap: () => setState(() => _hidden = !_hidden),
        child: Icon(
          _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: Colors.grey,
          size: 20,
        ),
      );
    }
    return widget.suffixIcon;
  }
}
