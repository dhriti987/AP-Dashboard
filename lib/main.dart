import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:streaming_data_dashboard/core/router/router.dart';
import 'package:streaming_data_dashboard/core/theme/common_theme.dart';
import 'package:streaming_data_dashboard/service_locator.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  setup();
  await dotenv.load(fileName: ".env");
  await windowManager.setMinimumSize(const Size(1000, 600));
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
