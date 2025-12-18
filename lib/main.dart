import 'Model/service_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/new_service_page.dart';
import 'screens/schedule_page.dart';
import 'screens/payments_page.dart';
import 'screens/clients_page.dart';
import 'screens/services_page.dart';
import 'screens/public_schedule_page.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/auth_provider.dart';
import 'more_detail.dart';

void main() {
  // Ensure proper initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for better experience
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Use Poppins font with text scaling properly set
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.black87,
            displayColor: Colors.black87,
          ),
          // Better contrast for text on various backgrounds
          primarySwatch: Colors.purple,
          // Adjust all material defaults to be more responsive
          cardTheme: CardThemeData(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Ensure we have proper contrast
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color(0xFF6A4C93),
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF6A4C93), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            labelStyle: const TextStyle(color: Colors.grey),
            floatingLabelStyle: const TextStyle(color: Color(0xFF6A4C93)),
          ),
        ),
        builder: (context, child) {
          // Ensure we respect the device's text scaling factor
          // but also set a sensible limit to avoid layout issues
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.3),
            ),
            child: child!,
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomePage(),
          '/new-service': (context) => const NewServicePage(),
          '/schedule': (context) => const SchedulePage(),
          '/payments': (context) => const PaymentsPage(),
          '/clients': (context) => const ClientsPage(),
          '/services': (context) => const ServicesPage(),
          '/public-schedule': (context) => const PublicSchedulePage(),
          '/subscription': (context) => const SubscriptionScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/service-detail') {
            final service = settings.arguments as ServiceItem;
            return MaterialPageRoute(
              builder: (context) => MoreDetail(service: service),
            );
          }
          if (settings.name == '/payment') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => PaymentScreen(
                plan: args['plan'],
                onPaymentSuccess: args['onPaymentSuccess'],
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}