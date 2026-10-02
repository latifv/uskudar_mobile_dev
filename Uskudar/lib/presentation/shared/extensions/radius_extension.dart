import 'package:flutter/widgets.dart';
import 'package:uskudar_mobile/presentation/shared/constants/radius_constants.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/media_query_extension.dart';

extension RadiusExtension on BuildContext {
  Radius get lowRadius => Radius.circular(screenWidth * RadiusConstants.low);
  Radius get normalRadius =>
      Radius.circular(screenWidth * RadiusConstants.normal);
  Radius get mediumRadius =>
      Radius.circular(screenWidth * RadiusConstants.medium);
  Radius get highRadius => Radius.circular(screenWidth * RadiusConstants.high);
}
