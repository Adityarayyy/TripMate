import 'package:appdev/itinerary_model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItineraryPage extends StatelessWidget {
  final String itinerary;

  const ItineraryPage({super.key, required this.itinerary});

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open link: $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Itinerary itineraryData = Itinerary.fromJson(itinerary);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Itinerary'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            itineraryData.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Lodging Options
          Text(
            "Lodging Options:",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...itineraryData.lodgingOptions.map((hotel) => ListTile(
                title: Text(hotel.hotelName),
                subtitle: Text("Price: ${hotel.price}"),
                trailing: IconButton(
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () {
                    debugPrint("Trying to open: ${hotel.link}");
                    _launchURL(context, hotel.link);
                  },
                ),
              )),

          const SizedBox(height: 20),
          Text(
            "Daily Plan:",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...itineraryData.days.map((day) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Day ${day.dayNumber}: ${day.title}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Morning:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(day.morning),
                    const SizedBox(height: 8),
                    Text("Afternoon:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(day.afternoon),
                    const SizedBox(height: 8),
                    Text("Evening:",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(day.evening),
                    const SizedBox(height: 10),
                    Text(
                      "Dinner: ${day.dinnerRecommendation.restaurantName}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),
          Text(
            "Budget-Friendly Tips:",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...itineraryData.budgetFriendlyTips.map((tip) => ListTile(
                leading: const Icon(Icons.monetization_on),
                title: Text(tip),
              )),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class ItineraryPage extends StatelessWidget {
//   final String itinerary;

//   const ItineraryPage({super.key, required this.itinerary});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Generated Itinerary")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Text(itinerary, style: TextStyle(fontSize: 16)),
//         ),
//       ),
//     );
//   }
//}
