import 'package:capricorn/src/widgets/home_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aquarius BOM Cost Estimator"),
      ),
      body: HomeWidget(),
    );
  }
}
