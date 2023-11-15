import 'package:dowajo/Screens/home_screen.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();

  //runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => MedicineModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        unselectedWidgetColor: const Color.fromARGB(255, 203, 202, 202),
        //primarySwatch: Colors.,
      ),
      home: const HomeScreen(),
    );
  }
}
