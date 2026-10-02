import 'package:flutter/widgets.dart';
import 'package:uskudar_mobile/presentation/shared/extensions/radius_extension.dart';

extension BorderRadiusExtension on BuildContext {
  BorderRadius get borderRadiusLowAll => BorderRadius.all(lowRadius);
  BorderRadius get borderRadiusNormalAll => BorderRadius.all(normalRadius);
  BorderRadius get borderRadiusMediumAll => BorderRadius.all(mediumRadius);
  BorderRadius get borderRadiusHighAll => BorderRadius.all(highRadius);

  BorderRadius get borderRadiusLowTop => BorderRadius.vertical(top: lowRadius);
  BorderRadius get borderRadiusNormalTop =>
      BorderRadius.vertical(top: normalRadius);
  BorderRadius get borderRadiusMediumTop =>
      BorderRadius.vertical(top: mediumRadius);
  BorderRadius get borderRadiusHighTop =>
      BorderRadius.vertical(top: highRadius);

  BorderRadius get borderRadiusLowBottom =>
      BorderRadius.vertical(bottom: lowRadius);
  BorderRadius get borderRadiusNormalBottom =>
      BorderRadius.vertical(bottom: normalRadius);
  BorderRadius get borderRadiusMediumBottom =>
      BorderRadius.vertical(bottom: mediumRadius);
  BorderRadius get borderRadiusHighBottom =>
      BorderRadius.vertical(bottom: highRadius);

  BorderRadius get borderRadiusLowLeft =>
      BorderRadius.only(topLeft: lowRadius, bottomLeft: lowRadius);
  BorderRadius get borderRadiusNormalLeft =>
      BorderRadius.only(topLeft: normalRadius, bottomLeft: normalRadius);
  BorderRadius get borderRadiusMediumLeft =>
      BorderRadius.only(topLeft: mediumRadius, bottomLeft: mediumRadius);
  BorderRadius get borderRadiusHighLeft =>
      BorderRadius.only(topLeft: highRadius, bottomLeft: highRadius);

  BorderRadius get borderRadiusLowRight =>
      BorderRadius.only(topRight: lowRadius, bottomRight: lowRadius);
  BorderRadius get borderRadiusNormalRight =>
      BorderRadius.only(topRight: normalRadius, bottomRight: normalRadius);
  BorderRadius get borderRadiusMediumRight =>
      BorderRadius.only(topRight: mediumRadius, bottomRight: mediumRadius);
  BorderRadius get borderRadiusHighRight =>
      BorderRadius.only(topRight: highRadius, bottomRight: highRadius);
}
