import '../widgets/media/media_utils.dart';

class MediaTypeIdentifier {
  static bool isMediaTypeIsVideo({required String url}) {
    if (url.contains('youtube') || url.contains('youtu.be')) {
      return true;
    }
    String ext = url.split('.').last.toLowerCase();
    return videoTypes.contains(ext);
  }

  static bool isMediaTypeIsYoutubeVideo({required String url}) {
    if (url.contains('youtube') || url.contains('youtu.be')) {
      return true;
    }
    return false;
  }

  static bool isMediaTypeIsImage({required String url}) {
    String ext = url.split('.').last.toLowerCase();
    return imageTypes.contains(ext);
  }

  static bool isMediaTypeIsDoc({required String url}) {
    String ext = url.split('.').last.toLowerCase();
    return docTypes.contains(ext);
  }

  static bool isMediaTypeIsAudio({required String url}) {
    String ext = url.split('.').last.toLowerCase();
    return audioTypes.contains(ext);
  }

  static bool isMediaTypeIsPDF({required String url}) {
    return (url.split('.').last).toLowerCase() == 'pdf';
  }

  static bool isMediaTypeIsSVGImage({required String url}) {
    return (url.split('.').last).toLowerCase() == 'svg';
  }
}
