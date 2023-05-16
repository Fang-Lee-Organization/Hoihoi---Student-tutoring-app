import 'package:Hoihoi/main_layout.dart';
import 'package:Hoihoi/models/auth_model.dart';
import 'package:Hoihoi/screens/appointment_page.dart';
import 'package:Hoihoi/screens/auth_page.dart';
import 'package:Hoihoi/screens/booking_page.dart';
import 'package:Hoihoi/screens/success_booked.dart';
import 'package:Hoihoi/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

void main() {
  runApp(const MyApp());
}

const googleApiKey = 'AIzaSyD1sRLh3eYI2svfLJ0hreKM5Yr7gEjOUxA';
GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: googleApiKey);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //this is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    //define ThemeData here
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'HoiHoi - Find tutor near you',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //pre-define input decoration
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'booking_page': (context) => BookingPage(),
          'success_booking': (context) => const AppointmentBooked(),
          'appointment': (context) => const AppointmentPage()
        },
      ),
    );
  }
}
