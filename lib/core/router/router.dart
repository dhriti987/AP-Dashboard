// import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  final SharedPreferences pref;

  AppRouter({required this.pref});

  bool checkIsAuthenticated() {
    return pref.getString('token') != null;
  }

  GoRouter getRouter() {
    GoRouter router = GoRouter(
      routes: [
        
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
        if (checkIsAuthenticated()) {
          return null;
        }
        return '/signin';
      },
    );
    return router;
  }
}
