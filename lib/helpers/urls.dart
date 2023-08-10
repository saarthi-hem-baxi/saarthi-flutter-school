import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIUrls {
  late String lmsUrl;
  late String baseUrl;
  late String authUrl;
  late String lmsSchoolUrl;
  late String registraionBaseUrl;
  late String communicationBaseUrl;
  late String communicationUrl;
  late String registraionUrl;
  late String communicationSocketUrl;
  late String communicationSocketPath;
  late String analyticsUrl;
  late String analyticsSocketUrl;
    late String unlockluckydrawurl;

  late String analyticsSocketPath;
  late String analyticsTimeout;
  late String dashboardUrl;
  late String productTourVideos;
  late String publisherUrl;
  late String conceptMapUrl;

  APIUrls() {
    lmsUrl = dotenv.env['API_URL'] ?? "";
    baseUrl = lmsUrl + "student/";
    lmsSchoolUrl = lmsUrl + "schools/";
    registraionBaseUrl = dotenv.env['SCHOOL_API_URL'] ?? "";
    communicationSocketUrl = dotenv.env['COMMUNICATION_SOCKET_URL'] ?? "";
    registraionUrl = registraionBaseUrl + "registration/";
    communicationBaseUrl = dotenv.env['COMMUNICATION_API_URL'] ?? "";
    communicationUrl = communicationBaseUrl + "communication/";
    authUrl = dotenv.env['BASE_URL'] ?? baseUrl + "auth/";
    communicationSocketPath = dotenv.env['COMMUNICATION_SOCKET_PATH'] ?? "";
    analyticsUrl = dotenv.env['ANALYTICS_API_URL'] ?? "";
    analyticsSocketUrl = dotenv.env['ANALYTICS_SOCKET_URL'] ?? "";
    analyticsSocketPath = dotenv.env['ANALYTICS_SOCKET_PATH'] ?? "";
    analyticsTimeout = dotenv.env['ANALYTICS_TIMEOUT_SECONDS'] ?? "5";
    dashboardUrl = analyticsUrl + "dashboard/";
    productTourVideos = baseUrl + "product-tour-videos/screen?";
    publisherUrl = dotenv.env['PUBLISHER_URL'] ?? "";
    conceptMapUrl = (dotenv.env['WEB_LMS_URL'] ?? "") + "concept-map/";
        unlockluckydrawurl = baseUrl + "lucky-draw/unlock-code";

  }
}
