import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:streaming_data_dashboard/core/router/router.dart';
import 'package:streaming_data_dashboard/core/theme/common_theme.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  await dotenv.load(fileName: ".env");
  sl.allReady().then((value) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: sl.get<AppRouter>().getRouter(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
    );
  }
}