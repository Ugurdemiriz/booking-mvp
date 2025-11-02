import 'package:flutter/material.dart';

import '../../common/widgets/app_scaffold.dart';

class SchedulingPage extends StatefulWidget {
  const SchedulingPage({super.key});

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  DateTime? _start;
  DateTime? _end;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Scheduling',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                        initialDate: now,
                      );
                      if (picked != null) {
                        setState(() => _start = DateTime(picked.year, picked.month, picked.day, 10));
                      }
                    },
                    child: Text(_start == null ? 'Pick start date' : _start.toString()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final base = _start ?? DateTime.now();
                      setState(() => _end = base.add(const Duration(hours: 1)));
                    },
                    child: Text(_end == null ? 'Auto set +1h' : _end.toString()),
                  ),
                ),
              ]),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _start != null && _end != null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Slot created (local)')));
                    // TODO: POST to /api/slots
                  }
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Create Slot'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

