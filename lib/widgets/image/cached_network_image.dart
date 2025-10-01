import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:playground/core/constants/asset_path.dart';
import 'package:playground/core/themes/styles.dart';

// String _getValidImageUrl(String? customUrl, String remoteAssetUrl) {
//   Uri? uri = Uri.tryParse(customUrl ?? remoteAssetUrl);

//   if (uri == null || !uri.hasAbsolutePath) {
//     uri = Uri.parse(remoteAssetUrl);
//   }

//   return uri.toString();
// }

class CustomCachedAssetImage extends StatelessWidget {
  const CustomCachedAssetImage(
    this.asset, {
    super.key,
    this.customUrl,
    this.width,
    this.height,
    this.color,
    this.fit,
  });

  final AssetPathEnum asset;
  final String? customUrl;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final defaultWidget = Image.asset(
      asset.localPath,
      width: width,
      height: height,
      color: color,
      fit: fit,
    );

    const placeholder = Icon(
      Icons.history,
      color: AppColors.primaryText,
    );

    return customUrl != null
        ? CachedNetworkImage(
            imageUrl: customUrl ?? '',
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 150),
            fadeOutDuration: const Duration(milliseconds: 150),
            color: color,
            fit: fit,
            errorWidget: (_, error, test) => placeholder,
            placeholder: (_, __) => placeholder,
          )
        : defaultWidget;
  }
}

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    super.key,
    required this.customUrl,
    this.color,
    this.width,
    this.height,
    this.fit,
    this.customErrorWidget,
    this.customPlaceholder,
  });

  final String? customUrl;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? customErrorWidget;
  final Widget? customPlaceholder;

  @override
  Widget build(BuildContext context) {
    const placeholder = Icon(
      Icons.history,
      color: AppColors.primaryText,
    );

    return customUrl != null
        ? CachedNetworkImage(
            imageUrl: customUrl ?? '',
            width: width,
            height: height,
            fadeInDuration: const Duration(milliseconds: 150),
            fadeOutDuration: const Duration(milliseconds: 150),
            color: color,
            fit: fit,
            errorWidget: (_, error, test) {
              return customErrorWidget ?? placeholder;
            },
            placeholder: (_, __) => customPlaceholder ?? placeholder,
          )
        : customPlaceholder ?? placeholder;
  }
}

class CustomCachedNetworkImageProvider extends StatelessWidget {
  const CustomCachedNetworkImageProvider({
    super.key,
    required this.asset,
    required this.builder,
    this.customUrl,
  });

  final Widget Function(ImageProvider) builder;
  final AssetPathEnum asset;
  final String? customUrl;

  @override
  Widget build(BuildContext context) {
    // final imageUrl = _getValidImageUrl(customUrl, asset.remotePath);

    return customUrl != null
        ? CachedNetworkImage(
            imageUrl: customUrl!,
            fadeInDuration: const Duration(milliseconds: 200),
            fadeOutDuration: const Duration(milliseconds: 200),
            errorWidget: (_, error, test) {
              return builder(AssetImage(asset.localPath));
            },
            placeholder: (_, __) {
              return builder(AssetImage(asset.localPath));
            },
            imageBuilder: (_, imageProvider) {
              return builder(imageProvider);
            },
          )
        : builder(AssetImage(asset.localPath));
  }
}
