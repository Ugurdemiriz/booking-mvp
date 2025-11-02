import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../common/widgets/app_scaffold.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
  String? meetUrl;
  bool loading = false;

  Future<void> _createMeetEvent() async {
    setState(() => loading = true);
    try {
      final res = await http.post(
        Uri.parse('$apiBaseUrl/api/calendar/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'summary': 'MVP Demo Meeting',
          'start': DateTime.now().add(const Duration(minutes: 5)).toIso8601String(),
          'end': DateTime.now().add(const Duration(minutes: 35)).toIso8601String(),
          'attendees': ['demo@example.com'],
        }),
      );
      if (res.statusCode == 201) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() => meetUrl = data['meetUrl'] as String?);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${res.statusCode}')));
      }
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Calendar',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Google Calendar event with one-tap Meet link.'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: loading ? null : _createMeetEvent,
              icon: const Icon(Icons.video_call_outlined),
              label: Text(loading ? 'Creating…' : 'Create Meet Event'),
            ),
            const SizedBox(height: 16),
            if (meetUrl != null) SelectableText('Meet URL: $meetUrl'),
          ],
        ),
      ),
    );
  }
}

