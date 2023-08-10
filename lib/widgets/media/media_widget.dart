import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';

import '../../helpers/network.dart';
import 'media_audio.dart';
import 'media_document.dart';
import 'media_image.dart';
import 'media_link.dart';
import 'media_pdf.dart';
import 'media_simulation.dart';
import 'media_utils.dart';
import 'media_video.dart';

class AppMediaWidget extends StatefulWidget {
  /// Please provide type when you know the type for reduce processing
  const AppMediaWidget({
    Key? key,
    required this.mediaUrl,
    this.thumbUrl,
    this.title,
    this.margin,
    this.customWidget,
    this.startTime,
    this.endTime,
    this.mediaType,
    this.size = 87,
    this.thumbnailBoxFit = BoxFit.cover,
  }) : super(key: key);

  final String mediaUrl;
  final String? thumbUrl;
  final String? title;
  final EdgeInsets? margin;
  final Widget? customWidget;
  final MediaTypes? mediaType;
  final int? size;
  final BoxFit? thumbnailBoxFit;

  /// use this parameter when you have video type
  final String? startTime;

  /// use this parameter when you have video type
  final String? endTime;

  @override
  State<AppMediaWidget> createState() => _AppMediaWidgetState();
}

class _AppMediaWidgetState extends State<AppMediaWidget> {
  final APIClient apiClient = APIClient();

  final dio.Dio dioClient = dio.Dio();

  Widget? mediaWidget;

  bool isLoaded = false;

  Future<bool> getMediaContentType({required String contentItemType}) async {
    try {
      dio.Response response = await dioClient.get(
        widget.mediaUrl,
      );
      if (response.statusCode == 200) {
        List<String>? contentType = response.headers['content-type'];
        return (contentType ?? []).where((e) => e.startsWith(contentItemType)).toList().isNotEmpty;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<MediaTypes> getMediaTypeFromUrl() async {
    //return type when user have passed explicit
    if (widget.mediaType == MediaTypes.image) {
      return MediaTypes.image;
    } else if (widget.mediaType == MediaTypes.audio) {
      return MediaTypes.audio;
    } else if (widget.mediaType == MediaTypes.video) {
      return MediaTypes.video;
    } else if (widget.mediaType == MediaTypes.pdf) {
      return MediaTypes.pdf;
    } else if (widget.mediaType == MediaTypes.doc) {
      return MediaTypes.doc;
    } else if (widget.mediaType == MediaTypes.simulation) {
      return MediaTypes.simulation;
    } else if (widget.mediaType == MediaTypes.link) {
      return MediaTypes.link;
    }

    if (isYoutubeUrl(url: widget.mediaUrl)) {
      return MediaTypes.video;
    }
    if (isExtensionExistInUrl(url: widget.mediaUrl)) {
      String extension = widget.mediaUrl.split('.').last.toLowerCase();
      if (imageTypes.map((e) => e.toLowerCase()).contains(extension)) {
        return MediaTypes.image;
      } else if (audioTypes.map((e) => e.toLowerCase()).contains(extension)) {
        return MediaTypes.audio;
      } else if (videoTypes.map((e) => e.toLowerCase()).contains(extension)) {
        return MediaTypes.video;
      } else if (extension == 'pdf') {
        return MediaTypes.pdf;
      } else if (docTypes.map((e) => e.toLowerCase()).contains(extension)) {
        return MediaTypes.doc;
      } else {
        return MediaTypes.link;
      }
    } else {
      if (await getMediaContentType(contentItemType: 'image')) {
        return MediaTypes.image;
      } else if (await getMediaContentType(contentItemType: 'audio')) {
        return MediaTypes.audio;
      } else if (await getMediaContentType(contentItemType: 'video')) {
        return MediaTypes.video;
      } else if (await getMediaContentType(contentItemType: 'application/pdf')) {
        return MediaTypes.pdf;
      } else if (await getMediaContentType(contentItemType: 'application')) {
        return MediaTypes.link;
      } else {
        return MediaTypes.link;
      }
    }
  }

  Future getMediaWidget() async {
    if (await getMediaTypeFromUrl() == MediaTypes.image) {
      mediaWidget = MediaImage(
        thumbUrl: widget.thumbUrl ?? "",
        imageUrl: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    } else if (await getMediaTypeFromUrl() == MediaTypes.audio) {
      mediaWidget = MediaAudio(
        audioUrl: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    } else if (await getMediaTypeFromUrl() == MediaTypes.video) {
      mediaWidget = MediaVideo(
        videoUrl: widget.mediaUrl,
        thumbUrl: widget.thumbUrl ?? "",
        startTime: widget.startTime ?? "",
        endTime: widget.endTime ?? "",
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
        thumbnailBoxFit: widget.thumbnailBoxFit,
      );
    } else if (await getMediaTypeFromUrl() == MediaTypes.pdf) {
      mediaWidget = MediaPdf(
        pdfUrl: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    } else if (await getMediaTypeFromUrl() == MediaTypes.doc) {
      mediaWidget = MediaDocument(
        docUrl: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    } else if (await getMediaTypeFromUrl() == MediaTypes.simulation) {
      mediaWidget = MediaSimulation(
        link: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    } else {
      mediaWidget = MediaLink(
        link: widget.mediaUrl,
        title: widget.title,
        margin: widget.margin,
        customWidget: widget.customWidget,
        size: widget.size,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMediaWidget(),
      builder: (context, snapshot) {
        return mediaWidget ?? const SizedBox();
      },
    );
  }
}
