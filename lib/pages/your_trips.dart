
import 'package:appdev/pages/itinerary_page.dart';
import 'package:appdev/pages/manage_budget.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class YourTripsPage extends StatefulWidget {
  @override
  _YourTripsPageState createState() => _YourTripsPageState();
}

class _YourTripsPageState extends State<YourTripsPage> {
  List<Map<String, String>> savedTrips = [];

  @override
  void initState() {
    super.initState();
    _loadSavedTrips();
  }

  // Future<void> _loadSavedTrips() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final List<FileSystemEntity> files = directory.listSync();

  //   List<Map<String, String>> trips = files
  //       .where((file) => file.path.endsWith('.pdf'))
  //       .map((file) => {
  //             'title': file.uri.pathSegments.last.replaceAll('.pdf', ''),
  //             'path': file.path,
  //           })
  //       .toList();

  //   setState(() {
  //     savedTrips = trips;
  //   });
  // }

  Future<void> _loadSavedTrips() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      print("Current user ID: $userId");

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not logged in.")),
        );
        return;
      }

      final response = await supabase
          .from('itineraries')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      setState(() {
        savedTrips = (response as List).map<Map<String, String>>((item) {
          return {
            'title': item['title'],
            'json': item['json_data'],
            'id': item['id']
          };
        }).toList();
      });
    } catch (e) {
      print('Failed to load trips: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error loading trips.")),
      );
    }
  }

  void _openPDF(String filePath) {
    OpenFile.open(filePath);
  }

  void _manageBudget(String tripTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Manage budget for $tripTitle")),
    );
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) =>BudgetManagerPage(itineraryId: ,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Trips", style: TextStyle(fontSize: 24)),
        ),
        body: savedTrips.isEmpty
            ? const Center(child: Text("No trips saved yet."))
            // : ListView.builder(
            //     itemCount: savedTrips.length,
            //     itemBuilder: (context, index) {
            //       final trip = savedTrips[index];
            //       return Card(
            //         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         child: ExpansionTile(

            //           collapsedShape: const RoundedRectangleBorder(),
            //           initiallyExpanded: false,

            //           tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            //           maintainState: true,
            //           title: Text(trip['title'] ?? "Trip", style: const TextStyle(fontSize: 20),),
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 8),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: [
            //                   ElevatedButton(
            //                     style: ElevatedButton.styleFrom(
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(10)
            //                       )
            //                     ),
            //                     onPressed: () => _openPDF(trip['path']!),
            //                     child: const Text("Show PDF"),
            //                   ),
            //                   ElevatedButton(
            //                     style: ElevatedButton.styleFrom(
            //                       shape: RoundedRectangleBorder(
            //                         borderRadius: BorderRadius.circular(10)
            //                       )
            //                     ),
            //                     onPressed: () => _manageBudget(trip['title']!),
            //                     child: const Text("Manage Budget"),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       );
            //     },
            //   ),

            : ListView.builder(
                itemCount: savedTrips.length,
                itemBuilder: (context, index) {
                  final trip = savedTrips[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ExpansionTile(
                      title: Text(trip['title'] ?? "Trip",
                          style: const TextStyle(fontSize: 20)),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ItineraryPage(
                                        itinerary: trip['json']!,
                                        userTitle: trip['title']!,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Open Itinerary"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
        context, MaterialPageRoute(builder: (context) =>BudgetManagerPage(itineraryId: trip['id']!,)));
                                },
                                child: const Text("Manage Budget"),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ));
  }
}
