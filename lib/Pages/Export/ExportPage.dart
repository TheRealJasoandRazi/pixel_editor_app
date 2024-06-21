import 'package:flutter/material.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight * 0.9,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Export Images",
                style: TextStyle(fontSize: 24.0), // Increased font size
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/ExportImagePage");
                },
                child: Container(
                  width: screenWidth * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 60.0, // Increased icon size
                    ),
                  ),
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700
                ),
                child: Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 24.0
                    ), // Increased font size
                  ),
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Export Animation (GIF)",
                style: TextStyle(fontSize: 24.0), // Increased font size
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "/ExportGifPage");
                },
                child: Container(
                  width: screenWidth * 0.10,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.video_call,
                      size: 60.0, // Increased icon size
                    ),
                  ),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel"
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}