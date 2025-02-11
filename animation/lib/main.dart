import 'package:flutter/material.dart';

void main() {
  runApp(AnimatedContainerApp());
}

class AnimatedContainerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Container',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AnimatedContainerScreen(),
    );
  }
}

class AnimatedContainerScreen extends StatefulWidget {
  @override
  _AnimatedContainerScreenState createState() =>
      _AnimatedContainerScreenState();
}

class _AnimatedContainerScreenState extends State<AnimatedContainerScreen> {
  // Initial properties of the container
  double _width = 100.0;
  double _height = 100.0;
  Color _color = Colors.red;

  // Method to trigger the animation
  void _animateContainer() {
    setState(() {
      _width = 200.0;
      _height = 200.0;
      _color = Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Container'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Container
            AnimatedContainer(
              duration: Duration(seconds: 1), // Animation duration
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius:
                    BorderRadius.circular(10.0), // Optional: Rounded corners
              ),
            ),
            SizedBox(height: 20),

            // Button to trigger the animation
            ElevatedButton(
              onPressed: _animateContainer,
              child: Text('Animate Container'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
