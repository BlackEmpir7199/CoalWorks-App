import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationDisplay extends StatelessWidget {
  final Position? currentPosition;
  final VoidCallback onRefresh;

  const LocationDisplay({
    Key? key,
    required this.currentPosition,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.black),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              currentPosition != null
                  ? 'Coordinates: ${currentPosition!.latitude}, ${currentPosition!.longitude}'
                  : 'Fetching location...',
              style: TextStyle(
                color: currentPosition != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
