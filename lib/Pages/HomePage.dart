import 'package:flutter/material.dart';
class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.25,
          height: screenHeight * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Let's get started!", style: Theme.of(context).textTheme.bodyText1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/CreateGridPage');
                },
                child: Text("Create Grid"),
              ),
              Text("OR"),
              Text("Start by using an image"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ImportPage');
                },
                child: Text("Import"),
              ),
            ],
          ),
        )
      )
    );
  }
}