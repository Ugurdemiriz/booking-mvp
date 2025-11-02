import 'package:flutter/material.dart';

import '../../common/widgets/app_scaffold.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Booking (Map)',
      body: Column(
        children: [
          // Placeholder: replace with GoogleMap widget after configuring keys
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: const Text('Map goes here (GoogleMap / Mapbox / OSM)'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search location',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    // TODO: trigger search & show slots
                  },
                  child: const Text('Find Slots'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

