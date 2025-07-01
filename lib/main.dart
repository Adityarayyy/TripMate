import 'package:appdev/components/deeplink.dart';
import 'package:appdev/components/forgetpassdialog.dart';
import 'package:appdev/pages/create_trip.dart';
import 'package:appdev/pages/documents.dart';
import 'package:appdev/pages/login.dart';
import 'package:appdev/pages/register.dart';
import 'package:appdev/pages/reset_password.dart';
import 'package:appdev/pages/tabs.dart';
import 'package:appdev/pages/upload_docs.dart';
import 'package:appdev/savedIineraries/delhi.dart';
import 'package:appdev/savedIineraries/goa.dart';
import 'package:appdev/savedIineraries/kolkata.dart';
import 'package:appdev/savedIineraries/shimla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final Color darkblue = Color(0xff03045e);

void main() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

// void main() async {
//   await dotenv.load(fileName: ".env");
//   await Supabase.initialize(
//       url: '${dotenv.env["URL"]}', anonKey: '${dotenv.env["ANONKEY"]}');
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
      super.initState();
    // Ensuring deep link configuration happens only once after the widget tree is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          if (mounted) {
            configureDeepLink(context);
          }
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff03045e),
            foregroundColor: Colors.white
          )
        ),
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.robotoTextTheme(),
        scaffoldBackgroundColor: Color(0xffedf2fb), // background color 
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(fontWeight: FontWeight.w500 , color: Color(0xff03045e) , fontSize: 32),
          foregroundColor:  Color(0xff03045e),
          // titleTextStyle: TextStyle(fontWeight: FontWeight.w500),
          backgroundColor: Color(0xffedf2fb)
        )
      ),
      initialRoute: '/login',
      routes: {
        '/tabs': (context) => TabsScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => RegisterPage(),
        '/uploadDocs': (context) => UploadPage(),
        '/createtrip': (context) => CreateTrip(),
        '/myDocs': (context) => MyDocuments(),
        '/delhi': (context) => DelhiItinerary(),
        '/goa': (context) => GoaItinerary(),
        '/kolkata': (context) => KolkataItinerary(),
        '/shimla': (context) => ShimlaItinerary(),
        '/updatepasswordpage': (context) => UpdatePasswordPage()
      },
    );
  }
}
