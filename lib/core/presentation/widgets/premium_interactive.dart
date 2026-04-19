import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A button that scales down slightly when pressed, providing high-quality tactile feedback.
class PremiumButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.textColor,
    this.icon,
    this.isLoading = false,
  });

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.color ?? const Color(0xFF005EB8);

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.isLoading ? null : widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: widget.isLoading ? Colors.grey : primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: widget.textColor ?? Colors.white, size: 20),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.label.toUpperCase(),
                        style: TextStyle(
                          color: widget.textColor ?? Colors.white,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// A "web-style" interactive link that animates an underline on tap/hover.
class PremiumLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const PremiumLink({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  State<PremiumLink> createState() => _PremiumLinkState();
}

class _PremiumLinkState extends State<PremiumLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) {
        setState(() => _isHovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isHovered = false),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: widget.style ??
                    const TextStyle(
                      color: Color(0xFF005EB8),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _isHovered ? null : 0, // Animate width
                color: const Color(0xFF005EB8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
