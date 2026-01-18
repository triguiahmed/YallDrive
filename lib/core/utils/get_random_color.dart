import 'dart:math';
import 'dart:ui';

Color getRandomColor() {
  final Random random = Random();
  return Color.fromARGB(
    255, // Alpha value (fully opaque)
    random.nextInt(256), // Red value
    random.nextInt(256), // Green value
    random.nextInt(256), // Blue value
  );
}
