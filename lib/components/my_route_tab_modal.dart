import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapsee/components/my_gribber.dart';
import 'package:mapsee/pages/customroute_detail_page.dart';
import 'package:mapsee/utils/common.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: MyRouteTabModal(),
      ),
    );
  }
}

class MyRouteTabModal extends StatefulWidget {
  const MyRouteTabModal({super.key});

  @override
  State<MyRouteTabModal> createState() => _MyRouteTabModalState();
}

class _MyRouteTabModalState extends State<MyRouteTabModal> {
  int? selectedIndex;
  List<Map<String, dynamic>> routes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    try {
      String? userId = await getUserId();
      final url =
          '${dotenv.env["API_BASE_URL"]}/route/get/customRoutesByUserID?user_id=$userId';
      final response = await http.get(Uri.parse(url));
      log(response.body);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          routes = List<Map<String, dynamic>>.from(jsonResponse['routes']);
          isLoading = false;
        });
      } else {
        // Handle error
        log('Failed to load routes');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching routes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.1,
      maxChildSize: 0.6,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          width: screenWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                const MyGribber(),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          child: Column(
                            children: [
                              const Text(
                                '내 경로 목록',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildListView(scrollController),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(ScrollController scrollController) {
    if (routes.isEmpty) {
      return const Center(
        child: Text(
          '아직 저장한 경로가 없어요',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: routes.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final title = routes[index]['title'] ?? 'No Title';
        final description = routes[index]['description'] ?? 'No Description';

        return ListTile(
          leading: const Icon(Icons.map, color: Colors.blue),
          title: Text(title),
          subtitle: Text(description),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomRouteDetailPage(customRoute: routes[index]),
              ),
            );
          },
        );
      },
    );
  }
}
