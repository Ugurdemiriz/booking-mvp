import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'common/widgets/app_scaffold.dart';
import 'features/booking/booking_page.dart';
import 'features/scheduling/scheduling_page.dart';
import 'features/calendar/calendar_page.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/booking', builder: (_, __) => const BookingPage()),
        GoRoute(path: '/scheduling', builder: (_, __) => const SchedulingPage()),
        GoRoute(path: '/calendar', builder: (_, __) => const CalendarPage()),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      routerConfig: router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'MVP Home',
      body: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            ElevatedButton.icon(
              onPressed: () => context.go('/booking'),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Booking'),
            ),
            ElevatedButton.icon(
              onPressed: () => context.go('/scheduling'),
              icon: const Icon(Icons.schedule_outlined),
              label: const Text('Scheduling'),
            ),
            ElevatedButton.icon(
              onPressed: () => context.go('/calendar'),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Calendar'),
            ),
          ],
        ),
      ),
    );
  }
}

