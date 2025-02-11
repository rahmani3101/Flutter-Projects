import 'package:flutter/material.dart';

void main() {
  runApp(ImageTransitionApp());
}

class ImageTransitionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Transition',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ImageTransitionScreen(),
    );
  }
}

class ImageTransitionScreen extends StatefulWidget {
  @override
  _ImageTransitionScreenState createState() => _ImageTransitionScreenState();
}

class _ImageTransitionScreenState extends State<ImageTransitionScreen> {
  bool _showFirstImage = true; // Toggle between the two images

  void _toggleImage() {
    setState(() {
      _showFirstImage = !_showFirstImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Transition'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedCrossFade for Smooth Image Transition
            AnimatedCrossFade(
              duration: Duration(seconds: 1), // Transition duration
              crossFadeState: _showFirstImage
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Image.network(
                'https://www.allaboutbirds.org/guide/assets/photo/303618951-480px.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              ),
              secondChild: Image.network(
                'https://www.shutterstock.com/image-vector/asad-name-arabic-diwani-calligraphy-600nw-2475698585.jpg',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(Icons.error, color: Colors.red, size: 50),
                  );
                },
              ),
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      key: bottomChildKey,
                      child: bottomChild,
                    ),
                    Positioned(
                      key: topChildKey,
                      child: topChild,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),

            // Button to Toggle Images
            ElevatedButton(
              onPressed: _toggleImage,
              child: Text(
                _showFirstImage ? 'Show Second Image' : 'Show First Image',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Colors.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
