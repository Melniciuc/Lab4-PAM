import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Font'),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> nearestBarbershops = [];
  List<dynamic> mostRecommended = [];
  List<dynamic> list = [];

  Future<void> loadJsonData() async {
    try {
      final String response = await rootBundle.loadString('assets/v2.json');
      final data = json.decode(response);

      setState(() {
        nearestBarbershops = data['nearest_barbershop'];
        mostRecommended = data['most_recommended'];
        list = data['list'];
      });
    } catch (e) {
      print('Error loading JSON data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              HeaderSection(),
              const SizedBox(height: 16),
              Image.asset(
                'assets/main_img2.png',
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              SearchComponent(),
              const SizedBox(height: 16),
              SectionLabel(label: "Nearest Barbershop"),
              BarberList(barberData: nearestBarbershops, isMostRecommended: false),
              const SizedBox(height: 16),
              ActionButton(),
              const SizedBox(height: 16),
              SectionLabel(label: "Most Recommended"),
              BarberList(barberData: mostRecommended, isMostRecommended: true),
              const SizedBox(height: 16),
              CarouselWidget(items: list),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Color(0xFF363062), width: 2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "See All",
              style: TextStyle(
                color: Color(0xFF363062),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_circle_right_outlined, color: Color(0xFF363062)),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, color: Color(0xFF363062)),
            SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Yogyakarta', style: TextStyle(color: Colors.grey)),
                Text(
                  'Joe Samanta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 23,
          backgroundImage: AssetImage('assets/prof_img.png'),
        ),
      ],
    );
  }
}

class SearchComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: TextStyle(color: Color(0xFF8683A1), fontSize: 14),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search barber's, haircut service...",
              hintStyle: TextStyle(color: Color(0xFF8683A1), fontSize: 14),
              fillColor: Color(0xFFEBF0F5),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFC8D5E1)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Color(0xFF363062),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, size: 20),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;

  const SectionLabel({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class BarberList extends StatelessWidget {
  final List<dynamic> barberData;
  final bool isMostRecommended;

  const BarberList({Key? key, required this.barberData, this.isMostRecommended = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: barberData.map((item) {
        return BarberProfile(
          barber: BarberInfo.fromJson(item),
          isMostRecommended: isMostRecommended,
        );
      }).toList(),
    );
  }
}

class BarberInfo {
  final String name;
  final String location;
  final double rating;
  final String imagePath;

  BarberInfo({
    required this.name,
    required this.location,
    required this.rating,
    required this.imagePath,
  });

  factory BarberInfo.fromJson(Map<String, dynamic> json) {
    return BarberInfo(
      name: json['name'],
      location: json['location_with_distance'],
      rating: json['review_rate'].toDouble(),
      imagePath: json['image'],
    );
  }
}

class BarberProfile extends StatelessWidget {
  final BarberInfo barber;
  final bool isMostRecommended;

  const BarberProfile({Key? key, required this.barber, this.isMostRecommended = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: isMostRecommended
          ? Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              height: 200,
              child: Image.network(
                barber.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barber.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF8683A1), size: 14),
                    Text(
                      barber.location,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF8683A1)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < barber.rating.round() ? Icons.star : Icons.star_border,
                      color: Color(0xFFFEC107),
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Container(
              width: 120,
              height: 120,
              child: Image.network(
                barber.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barber.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF8683A1), size: 16),
                    Text(
                      barber.location,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF8683A1)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < barber.rating.round() ? Icons.star : Icons.star_border,
                      color: Color(0xFFFEC107),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget pentru Carousel
class CarouselWidget extends StatelessWidget {
  final List<dynamic> items;

  const CarouselWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          var item = items[index];
          return Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(right: 16),
            child: SizedBox(
              width: screenWidth - 32,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Container(
                      width: 130,
                      height: 130,
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF8683A1), size: 14),
                            Text(
                              item['location_with_distance'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF8683A1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: List.generate(
                            5,
                                (index) => Icon(
                              index < item['review_rate'].round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Color(0xFFFEC107),
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
