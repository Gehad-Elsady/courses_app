import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdsPart extends StatelessWidget {
  const AdsPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E0094),
            Color(0xFF2D05CE),
          ],
        ),
      ),
      height: 203,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Secure the Online World",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8), // Added spacing
                  Text(
                    "Let's get you started with Cyber Security",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.white70, // Slightly dim for better contrast
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      fixedSize: const Size(127, 26),
                    ),
                    onPressed: () {},
                    child: Text("Enroll for Free"),
                  )
                ],
              ),
            ),
            Image.asset(
              "assets/images/Group.png",
              width: 100,
              fit: BoxFit.contain, // Ensures proper image scaling
            ),
          ],
        ),
      ),
    );
  }
}
