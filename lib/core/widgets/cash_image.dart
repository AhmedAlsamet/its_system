import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:its_system/statics_values.dart';



class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey
                ),
      child: CachedNetworkImage(
        cacheKey: StaticValue.serverPath! + imagePath,
        imageUrl: StaticValue.serverPath! + imagePath,
        imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage:  imageProvider,
        // child: Image.file(
        //   orderorImage,
        //   errorBuilder: (
        //     context,
        //     error,
        //     stackTrace,
        //   ) {
        //     return SizedBox(
        //       child: Image.asset("assets/logo.png"),
        //     );
        //   },
        //   fit: BoxFit.cover,
        // ),
      ),
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}