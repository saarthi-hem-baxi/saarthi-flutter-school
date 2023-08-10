import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:saarthi_pedagogy_studentapp/my_app.dart';

import 'firebase_options.dart';
import 'helpers/firebase_messging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initializing firebase app
  if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    //initializing google anyalytics
    FirebaseAnalytics.instance;

    //initializing crashalytics
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    //initializing firebase dynamic links
    FirebaseDynamicLinks.instance;

    //initializing firebase messaging
    FirebaseMessagingHandler.instance;

    FirebaseMessagingHandler.onTapNotification(); //this handler will handle notification on tap action
  }

  await dotenv.load();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => const MyApp(),
      ),
    );
  });
}
