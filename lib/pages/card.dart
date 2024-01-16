import 'package:flutter/material.dart';

class CardPage extends StatelessWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OptiSyncEnablers'),
          backgroundColor: Colors.greenAccent[400],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(
                title: 'Shubham Bayas',
                description:
                'In this flutter app, the Center is the parent widget to all, which is holding Card widget as a child. The properties of Card widget. ',
                screenWidth: screenWidth,
                imagePath: 'assets/login_logo.png', // Replace with your PNG image path
              ),
              _buildCard(
                title: 'Your Second Card',
                description:
                'This is the second card description. Make sure to replace it with your actual content. This is a long description that goes beyond one line and should be truncated with an ellipsis.',
                screenWidth: screenWidth,
                imagePath: 'assets/login_logo.png', // Replace with your PNG image path
              ),
              _buildCard(
                title: 'Your Third Card',
                description:
                'This is the third card description. Make sure to replace it with your actual content.',
                screenWidth: screenWidth,
                imagePath: 'assets/login_logo.png', // Replace with your PNG image path
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required double screenWidth,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 15,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.grey[300],
        child: SizedBox(
          width: screenWidth - 20,
          height: 250,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black, // Background color
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  width: screenWidth - 50,
                  margin: const EdgeInsets.only(left: 0.0),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white, // Text color
                    ),
                    maxLines: 1, // Maximum number of lines
                    overflow: TextOverflow.ellipsis, // Display ellipsis (...) when overflow
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.only(top: 100.0), // Add margin top to the image
                  width: screenWidth / 2 - 10,
                  height: 120,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.fill, // Make the image fill the box
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                child: SizedBox(
                  width: screenWidth - 60,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0C180D),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const CardPage());
}
