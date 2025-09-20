import 'Model/service_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'screens/new_service_page.dart';
import 'screens/schedule_page.dart';
import 'screens/payments_page.dart';
import 'screens/clients_page.dart';
import 'screens/public_schedule_page.dart';
import 'more_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      routes: {
        '/new-service': (context) => const NewServicePage(),
        '/schedule': (context) => const SchedulePage(),
        '/payments': (context) => const PaymentsPage(),
        '/clients': (context) => const ClientsPage(),
        '/public-schedule': (context) => const PublicSchedulePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/service-detail') {
          final service = settings.arguments as ServiceItem;
          return MaterialPageRoute(
            builder: (context) => MoreDetail(service: service),
          );
        }
        return null;
      },
    );
  }
}