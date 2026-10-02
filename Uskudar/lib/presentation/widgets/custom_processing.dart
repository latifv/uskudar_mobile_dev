import 'package:flutter/material.dart';
import 'package:uskudar_mobile/presentation/widgets/custom_loading.dart';

final class CustomProcessing extends StatelessWidget {
  const CustomProcessing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withAlpha(128),
      child: const Center(child: CustomLoading()),
    );
  }
}
