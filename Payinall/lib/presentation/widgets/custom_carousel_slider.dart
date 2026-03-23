import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:payinall/presentation/shared/components/image_network_component.dart';
import 'package:payinall/presentation/shared/extensions/border_radius_extension.dart';
import 'package:payinall/presentation/shared/extensions/media_query_extension.dart';

final class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({
    required this.images,
    this.heightFactor = .25,
    this.autoPlay = true,
    this.enlargeCenterPage = true,
    this.viewportFraction = 1,
    super.key,
  });

  final List<String> images;
  final double heightFactor;
  final bool autoPlay;
  final bool enlargeCenterPage;
  final double viewportFraction;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      itemBuilder: (context, index, _) {
        return ClipRRect(
          borderRadius: context.borderRadiusLowAll,
          child: ImageNetworkComponent(
            imageUrl: images[index],
            width: double.infinity,
          ),
        );
      },
      options: CarouselOptions(
        height: context.dynamicHeight(heightFactor),
        autoPlay: autoPlay,
        enlargeCenterPage: enlargeCenterPage,
        viewportFraction: viewportFraction,
      ),
    );
  }
}
