import 'package:flutter/material.dart';

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asad Cafe',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Papyrus',
      ),
      home: HomeScreen(),
      routes: {
        '/pizza': (context) => FoodCategoryScreen(category: 'Pizza'),
        '/burger': (context) => FoodCategoryScreen(category: 'Burgers'),
        '/bbq': (context) => FoodCategoryScreen(category: 'BBQ'),
        '/dessert': (context) => FoodCategoryScreen(category: 'Desserts'),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cuisineList = [
    {
      'name': 'Pizza',
      'icon': Icons.local_pizza,
      'route': '/pizza',
    },
    {
      'name': 'Burgers',
      'icon': Icons.lunch_dining,
      'route': '/burger',
    },
    {
      'name': 'BBQ',
      'icon': Icons.outdoor_grill,
      'route': '/bbq',
    },
    {
      'name': 'Desserts',
      'icon': Icons.icecream,
      'route': '/dessert',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asad Cafe',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 4,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1544025162-d76694265947',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Cuisine List',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore our delicious menu',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ...cuisineList.map((cuisine) => ListTile(
                  leading: Icon(cuisine['icon'], color: Colors.deepOrange),
                  title: Text(cuisine['name']),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, cuisine['route']);
                  },
                )),
          ],
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: cuisineList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () =>
                Navigator.pushNamed(context, cuisineList[index]['route']),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cuisineList[index]['icon'],
                    size: 48,
                    color: Colors.deepOrange,
                  ),
                  SizedBox(height: 8),
                  Text(
                    cuisineList[index]['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/pizza'),
        child: Icon(Icons.local_pizza),
        tooltip: 'View Pizzas',
      ),
    );
  }
}

class FoodCategoryScreen extends StatelessWidget {
  final String category;

  FoodCategoryScreen({required this.category});

  Map<String, List<Map<String, String>>> foodItems = {
    'Pizza': [
      {
        'name': 'Margherita Pizza',
        'image': 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
        'price': 'Rs. 499',
      },
      {
        'name': 'Pepperoni Pizza',
        'image': 'https://images.unsplash.com/photo-1628840042765-356cda07504e',
        'price': 'Rs. 359',
      },
      {
        'name': 'Vegetarian Pizza',
        'image': 'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e',
        'price': 'Rs. 300',
      },
    ],
    'Burgers': [
      {
        'name': 'Classic Burger',
        'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
        'price': 'Rs. 163',
      },
      {
        'name': 'Cheese Burger',
        'image': 'https://images.unsplash.com/photo-1550317138-10000687a72b',
        'price': 'Rs. 149',
      },
      {
        'name': 'Veggie Burger',
        'image': 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2',
        'price': 'Rs. 129',
      },
    ],
    'BBQ': [
      {
        'name': 'BBQ Ribs',
        'image': 'https://images.unsplash.com/photo-1544025162-d76694265947',
        'price': 'Rs. 385',
      },
      {
        'name': 'Grilled Chicken',
        'image': 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6',
        'price': 'Rs. 599',
      },
      {
        'name': 'BBQ Pulled ',
        'image': 'https://images.unsplash.com/photo-1529193591184-b1d58069ecdd',
        'price': 'Rs. 1985',
      },
    ],
    'Desserts': [
      {
        'name': 'Chocolate Cake',
        'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587',
        'price': 'Rs. 1678',
      },
      {
        'name': 'Ice Cream Sundae',
        'image': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb',
        'price': 'Rs. 320',
      },
      {
        'name': 'Apple Pie',
        'image':
            'https://www.foodandwine.com/thmb/2BC9mOqmfeD_3ixO8UQcQW_OVlE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/old-fashioned-apple-pie-FT-RECIPE1024-659641b5e78d4280840da7e08dd2e2c4.jpeg',
        'price': 'Rs.200',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        elevation: 4,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: foodItems[category]?.length ?? 0,
        itemBuilder: (context, index) {
          final item = foodItems[category]![index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    item['image']!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item['price']!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
