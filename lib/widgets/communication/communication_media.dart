import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../theme/colors.dart';
import '../../helpers/const.dart';
import '../common/custom_network_image.dart';
import '../media/media_utils.dart';

class MediaWidget extends StatefulWidget {
  final String url;
  final String thumbUrl;

  const MediaWidget({Key? key, required this.url, required this.thumbUrl})
      : super(key: key);

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  // ignore: unused_field
  String? _thumbnailFile;
  bool isLoaded = false;

  MediaTypes handleMedia(String url) {
    var ext = url.split(".").last.toLowerCase();
    if (ext == "pdf") {
      return MediaTypes.pdf;
    } else if (docTypes.contains(ext)) {
      return MediaTypes.doc;
    } else if (audioTypes.contains(ext)) {
      return MediaTypes.audio;
    } else if (videoTypes.contains(ext)) {
      return MediaTypes.video;
    } else if (imageTypes.contains(ext)) {
      return MediaTypes.image;
    } else {
      return MediaTypes.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (handleMedia(widget.url) == MediaTypes.pdf) {
      return const MediaIconWidget(
        imagePath: 'lessonplan/pdf_thumb.svg',
      );
    } else if (handleMedia(widget.url) == MediaTypes.doc) {
      return const MediaIconWidget(
        imagePath: 'lessonplan/doc_thumb.svg',
      );
    } else if (handleMedia(widget.url) == MediaTypes.audio) {
      return const MediaIconWidget(
        imagePath: "lessonplan/audio_thumb.svg",
      );
    } else if (handleMedia(widget.url) == MediaTypes.image) {
      return CustomNetworkImage(imageUrl: widget.url);
    } else if (handleMedia(widget.url) == MediaTypes.video) {
      // generateThumbnail(widget.url.replaceAll(' ', '%20'));
      return VideoIconWidget(
        imagePath: widget.thumbUrl,
        isLoaded: isLoaded,
      );
    }
    return const Text("data");
  }

  void generateThumbnail(String url) async {
    _thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: url,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight:
          87, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    if (!isLoaded) {
      setState(() {
        if (mounted) {
          isLoaded = true;
        }
      });
    }
  }
}

class MediaIconWidget extends StatelessWidget {
  final String imagePath;
  final double size;

  const MediaIconWidget({
    Key? key,
    required this.imagePath,
    this.size = 87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: colorPurpleLight,
      ),
      alignment: AlignmentDirectional.center,
      child: SizedBox(
        height: size,
        width: size,
        child: SvgPicture.asset(
          imageAssets + imagePath,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class VideoIconWidget extends StatefulWidget {
  final String imagePath;
  final bool isLoaded;

  const VideoIconWidget({
    Key? key,
    required this.imagePath,
    required this.isLoaded,
  }) : super(key: key);

  @override
  State<VideoIconWidget> createState() => _VideoIconWidgetState();
}

class _VideoIconWidgetState extends State<VideoIconWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        child: Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
              height: 87.w,
              width: 87.w,
              child: widget.imagePath.isNotEmpty
                  ? CustomNetworkImage(imageUrl: widget.imagePath)
                  : const CircularProgressIndicator(
                      color: colorPink,
                      strokeWidth: 1,
                    )),
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black12,
          child: Image.asset(
            imageAssets + 'communication_video.png',
          ),
        )
      ],
    ));
  }
}
