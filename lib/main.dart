import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:streaming_data_dashboard/core/router/router.dart';
import 'package:streaming_data_dashboard/core/theme/common_theme.dart';
import 'package:streaming_data_dashboard/service_locator.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setup();
  sl.allReady().then((value) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (value) async {
        if ((value is KeyUpEvent) && (value.physicalKey.debugName == "F11")) {
          windowManager.maximize();
          windowManager.setFullScreen(!(await windowManager.isFullScreen()));
        }
      },
      child: MaterialApp.router(
        routerConfig: sl.get<AppRouter>().getRouter(),
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
      ),
    );
  }
}
