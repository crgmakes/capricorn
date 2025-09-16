import 'package:capricorn/src/widgets/file_picker_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aquarius BOM Cost Estimator"),
      ),
      body: RawScrollbar(
        controller: _scrollController,
        thickness: 10,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: FilePickerWidget(),
        ),
      ),
    );
  }
}
