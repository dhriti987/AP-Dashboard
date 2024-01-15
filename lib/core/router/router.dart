// import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_data_dashboard/features/home/UI/home_screen.dart';

class AppRouter {
  final SharedPreferences pref;

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
        
        // GoRoute(
        //   path: '/book_reader',
        //   name: 'BookReader',
        //   builder: (context, state) {
        //     BookModel data = state.extra as BookModel;
        //     return BookReader(book: data);
        //   },
        // ),
      ],
    );
    return router;
  }
}