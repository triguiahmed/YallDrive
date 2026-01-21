import 'package:flutter/material.dart';
import 'package:yaladrive/core/theme/app_pallete.dart';

class FavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback? onPressed;
  final double size;
  final bool showBackground;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    this.onPressed,
    this.size = 24,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      isFavorited ? Icons.favorite : Icons.favorite_border,
      color: isFavorited ? Colors.red : Colors.grey,
      size: size,
    );

    if (showBackground) {
      return Material(
        color: Colors.white.withOpacity(0.9),
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(size * 0.35),
            child: icon,
          ),
        ),
      );
    }

    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: size,
    );
  }
}

class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final ValueChanged<bool>? onChanged;
  final double size;

  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorited,
    this.onChanged,
    this.size = 24,
  });

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onChanged?.call(!widget.isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: EdgeInsets.all(widget.size * 0.35),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            widget.isFavorited ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorited ? Colors.red : Colors.grey,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
