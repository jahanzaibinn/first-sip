
import 'package:material_ui/material_ui.dart';

class HeroSectionScreen extends StatelessWidget {
  const HeroSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F7), // Light off-white background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            // STACK controls the Z-index (layering order)
            child: Stack(
              clipBehavior: Clip.none, // Allows the line to bleed off the left edge
              children: [
                // LAYER 1 (Bottom): The main layout column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Invisible placeholder space for the text so the layout flows naturally,
                    // OR we put the purple card here and render text in Layer 3.
                    const SizedBox(height: 150), // Adjust based on your text height

                    // The Purple Preview Card
                    Container(
                      height: 320,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB4B8EA), // Soft periwinkle/purple
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "A little wild.\nEntirely\nthoughtful.",
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'Serif',
                              color: Color(0xFF1E1E2C),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // LAYER 2 (Middle): The Yellow Curved Line
                // Positioned above the purple card, but BELOW the headline text!
                Positioned(
                  top: -20,
                  left: -30, // Bleeds off the left side of the screen
                  right: 0,
                  height: 260,
                  child: CustomPaint(
                    painter: YellowCurvePainter(),
                  ),
                ),

                // LAYER 3 (Top): The Headline Text
                // Placed last in the Stack so it sits ON TOP of the yellow line
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 40.0), // Indented first line
                      child: Text(
                        "Head in the clouds.",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF141414),
                          letterSpacing: -1.0,
                          height: 1.15,
                        ),
                      ),
                    ),
                    Text(
                      "Hands on the anvil.",
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF141414),
                        letterSpacing: -1.0,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw the smooth organic yellow line
class YellowCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFBC02D) // Warm golden yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9.0
      ..strokeCap = StrokeCap.round; // Gives the smooth rounded tip at the end

    final path = Path();

    // Start off-screen to the top-left
    path.moveTo(0, 15);

    // Draw a cubic Bezier curve sweeping right, then curving down and inward
    path.cubicTo(
      size.width * 0.45, // Control point 1 X (pulls curve to the right)
      5,                 // Control point 1 Y (keeps top relatively flat)
      size.width * 0.58, // Control point 2 X (creates the outer right belly of the curve)
      size.height * 0.65,// Control point 2 Y
      size.width * 0.35, // End point X (hooks back inward over the purple card)
      size.height * 0.88,// End point Y
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}