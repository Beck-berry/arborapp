import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({required this.cim, super.key});

  final String cim;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cim),
      ),
      body: const Center(
        child: LoadingIndicator(
          indicatorType: Indicator.ballSpinFadeLoader,
        ),
      ),
    );
  }
}
