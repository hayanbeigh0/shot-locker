import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shot_locker/config/api_manager.dart';
import 'no_image.dart';

const String _errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';

class DisplayImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  const DisplayImage({
    Key? key,
    required this.imageUrl,
    this.width = 1000.0,
    this.height = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: imageUrl == null
          ? _errorImage
          : '${ApiManager.hostIp}/media/$imageUrl',
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.grey),
            strokeWidth: 2.0,
            value: downloadProgress.progress),
      ),
      errorWidget: (context, url, error) {
        return const NoImageAvailable();
      },
    );
  }
}
