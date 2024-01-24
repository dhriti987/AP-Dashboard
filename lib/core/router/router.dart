// import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/features/dashboard/UI/dashboard_page.dart';
import 'package:streaming_data_dashboard/features/home/UI/home_screen.dart';
import 'package:streaming_data_dashboard/features/login/UI/login.dart';
import 'package:streaming_data_dashboard/features/settings/UI/settings_page.dart';
import 'package:streaming_data_dashboard/features/units_edit/UI/unit_edit_page.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';

class AppRouter {
  final SharedPreferences pref;
  bool isAuthenticated = true;

  AppRouter({required this.pref});

  // bool checkIsAuthenticated() {
  //   return pref.getString('token') != null;
  // }

  GoRouter getRouter() {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'Home',
          builder: (context, state) {
            return HomePage();
          },
        ),
        GoRoute(
          path: '/settings',
          name: 'Settings',
          builder: (context, state) {
            return SettingsPage();
          },
        ),
        GoRoute(
          path: '/login',
          name: 'Login',
          builder: (context, state) {
            return LoginPage();
          },
        ),
        GoRoute(
          path: '/edit-units',
          name: 'EditUnits',
          builder: (context, state) {
            Plant data = state.extra as Plant;
            // print(data);
            return UnitEditPage(
              // plant: Plant(name: "Mundra"),
              plant: data,
            );
          },
        ),
        GoRoute(
          path: '/dashboard',
          name: 'Dashboard',
          builder: (context, state) {
            Plant data = state.extra as Plant;
            // print(data);
            return DashboardPage(
              // plant: Plant(name: "Mundra"),
              plant: data,
            );
          },
        ),

        // GoRoute(
        //   path: '/book_reader',
        //   name: 'BookReader',
        //   builder: (context, state) {
        //     BookModel data = state.extra as BookModel;
        //     return BookReader(book: data);
        //   },
        // ),
      ],
      redirect: (context, state) {
        if (isAuthenticated == false) return "/login";
        return null;
      },
    );
    return router;
  }
}
