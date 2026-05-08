import 'package:flutter/material.dart';
import '../utils/constants.dart';

// Real map er jonno add korun: google_maps_flutter: ^2.9.0
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // GoogleMapController? _mapController;

  // Demo disaster markers
  final List<Map<String, dynamic>> _demoMarkers = [
    {
      'title': 'বন্যা এলাকা',
      'lat': 23.8223,
      'lng': 90.3654,
      'type': 'flood',
      'color': Colors.blue,
    },
    {
      'title': 'আটকা পড়া মানুষ',
      'lat': 23.7636,
      'lng': 90.3567,
      'type': 'rescue',
      'color': Colors.red,
    },
    {
      'title': 'Relief Camp',
      'lat': 23.7903,
      'lng': 90.4125,
      'type': 'camp',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Map',
            style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 80, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'Google Map ekhane load hobe',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'pubspec.yaml e add korun:\ngoogle_maps_flutter: ^2.9.0',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Disaster list
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _demoMarkers.length,
              itemBuilder: (context, index) {
                final marker = _demoMarkers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: marker['color'] as Color,
                    child: const Icon(Icons.location_on,
                        color: Colors.white, size: 18),
                  ),
                  title: Text(marker['title'],
                      style:
                          const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Lat: ${marker['lat']}, Lng: ${marker['lng']}'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('View'),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Real GoogleMap:
      // body: GoogleMap(
      //   initialCameraPosition: CameraPosition(
      //     target: LatLng(23.8103, 90.4125), // Dhaka center
      //     zoom: 11,
      //   ),
      //   onMapCreated: (controller) => _mapController = controller,
      //   markers: _buildMarkers(),
      // ),
    );
  }
}
