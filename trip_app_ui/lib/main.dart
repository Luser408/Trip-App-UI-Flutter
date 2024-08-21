import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ),
);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;

  void _onScroll() {}

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8, // Added for smooth page transition
    )..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemCount: 4,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.3)).clamp(0.8, 1.0);
              }
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: makePage(
              images: _getImageForIndex(index),
              title: _getTitleForIndex(index),
              description: _getDescriptionForIndex(index),
              fixedRating: index == 0 ? 4.0 : null, // K2 BaseCamp has fixed rating
              fixedStars: index == 0 ? 4 : null, // K2 BaseCamp has 4 stars
            ),
          );
        },
      ),
    );
  }

  String _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return 'assets/images/k2.jpg';
      case 1:
        return 'assets/images/shangrilla.jpg';
      case 2:
        return 'assets/images/fairy-medow.jpg';
      case 3:
        return 'assets/images/blackforest1.jpg';
      default:
        return 'assets/images/k2.jpg';
    }
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return 'K2 BaseCamp';
      case 1:
        return 'Shangrilla Resort';
      case 2:
        return 'Fairy Meadows';
      case 3:
        return 'Black Forest';
      default:
        return 'K2 BaseCamp';
    }
  }

  String _getDescriptionForIndex(int index) {
    switch (index) {
      case 0:
        return 'Standing at 8,611 meters, K2 is the second-highest mountain in the world. Known as the "Savage Mountain," it challenges even the most skilled mountaineers. This awe-inspiring peak in the Karakoram Range is a true test of endurance and spirit.';
      case 1:
        return 'A slice of heaven on earth, Shangrilla Resort is nestled in the breathtaking Skardu valley. Surrounded by towering mountains and crystal-clear lakes, it’s a paradise for nature lovers and adventurers alike.';
      case 2:
        return 'A lush green plateau at the base of Nanga Parbat, Fairy Meadows offers some of the most stunning views in the world. It’s the perfect gateway to experience the grandeur of the Himalayas in all their glory.';
      case 3:
        return 'Enigmatic and dense, the Black Forest is a place of legends. The towering trees and misty atmosphere create an enchanting world where nature’s beauty and mystery intertwine seamlessly.';
      default:
        return 'Standing at 8,611 meters, K2 is the second-highest mountain in the world. Known as the "Savage Mountain," it challenges even the most skilled mountaineers. This awe-inspiring peak in the Karakoram Range is a true test of endurance and spirit.';
    }
  }

  Widget makePage({
    required String images,
    required String title,
    String? description,
    double? fixedRating,
    int? fixedStars,
  }) {
    final random = Random();
    int stars = fixedStars ?? random.nextInt(6);
    double rating = fixedRating ?? (stars + random.nextDouble()).clamp(1.0, 5.0);
    int reviews = random.nextInt(5000) + 500;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(images),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.2), // Adjusted for brightness
            BlendMode.darken,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            stops: [0.2, 0.9],
            colors: [
              Colors.black.withOpacity(.6),
              Colors.black.withOpacity(.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 60),
              AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 500),
                child: Text(
                  '${_currentPage + 1}/4',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AnimatedDefaultTextStyle(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      duration: Duration(milliseconds: 500),
                      child: Text(title),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: List.generate(5, (index) {
                        return Container(
                          margin: EdgeInsets.only(right: 3),
                          child: Icon(
                            Icons.star,
                            color: index < stars ? Colors.yellow : Colors.grey,
                            size: 20,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        Text(
                          ' ($reviews)',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 30), // Increased spacing between description and stars
                    if (description != null && description.isNotEmpty)
                      AnimatedDefaultTextStyle(
                        style: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          height: 1.9,
                          fontSize: 16,
                        ),
                        duration: Duration(milliseconds: 500),
                        child: Text(description),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
