import 'package:car_rental_app_clean_arch/core/constants/constants.dart';
import 'package:car_rental_app_clean_arch/core/routes/app_routes.dart';
import 'package:car_rental_app_clean_arch/core/utils/location_service.dart';
import 'package:flutter/material.dart';

class BookingHeroSection extends StatefulWidget {
  final VoidCallback onLoad;
  const BookingHeroSection({
    super.key,
    required this.onLoad,
  });

  @override
  State<BookingHeroSection> createState() => _BookingHeroSectionState();
}

class _BookingHeroSectionState extends State<BookingHeroSection> {
  @override
  void initState() {
    super.initState();
    widget.onLoad();
  }

  final TextEditingController searchController = TextEditingController();
  List<String> _suggestions = [];

  Future<void> updateSuggestions(String input) async {
    final suggestions = await LocationService.fetchSuggestions(input);
    setState(() => _suggestions = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: 380,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Constants.homePageCarImg),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          bottom: 30,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(150),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Find your drive',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        Positioned(
          top: 80,
          left: 20,
          right: 20,
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: updateSuggestions,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.purple),
                    hintText: 'City, airport, address, or hotel',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      final res = await Navigator.pushNamed(
                        context,
                        AppRoutes.getCarsByLocation,
                        arguments: {'location': value},
                      );
                      if (res == true) {
                        widget.onLoad();
                      }
                    }
                  },
                ),
              ),

              if (_suggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) => ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.purple),
                        title: Text(_suggestions[index]),
                        onTap: () {
                          setState(() {
                            searchController.text = _suggestions[index];
                            _suggestions.clear();
                          });
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
