import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';
import 'package:payinall/presentation/shared/constants/icon_asset_constants.dart';

final class ImageNetworkComponent extends StatelessWidget {
  const ImageNetworkComponent({
    required this.imageUrl,
    super.key,
    this.fit = BoxFit.fill,
    this.errorAssetImagePath,
    this.circularProgressColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
  });

  final String? imageUrl;
  final String? errorAssetImagePath;
  final BoxFit fit;
  final Color? circularProgressColor;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final child = imageUrl?.isNotEmpty ?? false
        ? CachedNetworkImage(
            imageUrl: imageUrl!,
            fit: fit,
            width: width,
            height: height,
            progressIndicatorBuilder: _buildProgressIndicator,
            errorWidget: _buildErrorWidget,
            errorListener: _handleError,
          )
        : _buildPlaceholderImage();

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: _applyPadding(child),
      );
    }

    return _applyPadding(child);
  }

  Widget _buildProgressIndicator(
    BuildContext context,
    String url,
    DownloadProgress downloadProgress,
  ) {
    return Center(
      child: CircularProgressIndicator(
        value: downloadProgress.progress,
        valueColor: circularProgressColor != null
            ? AlwaysStoppedAnimation<Color?>(circularProgressColor)
            : null,
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String url, dynamic error) {
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      errorAssetImagePath ?? IconAssetsConstants.logo,
      fit: fit,
      width: width,
      height: height,
    );
  }

  void _handleError(Object exception) {
    LogHelper.log(LogLevel.error, 'ImageNetworkComponent HATA: $exception');
  }

  Widget _applyPadding(Widget child) {
    return padding != null ? Padding(padding: padding!, child: child) : child;
  }
}
