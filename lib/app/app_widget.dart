import 'package:flutter/material.dart';

import 'view/home_view.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja Outsider',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}