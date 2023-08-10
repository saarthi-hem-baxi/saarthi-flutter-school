import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../helpers/webview_common_string.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

// ignore: must_be_immutable
class CustomWebView extends StatefulWidget {
  CustomWebView({
    Key? key,
    required this.htmlString,
    this.extraHeight = 20,
    this.headElements = '',
    this.scripts = '',
    this.bodyBgColor = 'white',
    this.updatedHeight,
    this.webViewController,
    this.updateWebViewObject,
    this.eventCallBack,
    this.fixedHeight,
    this.maxHeight = 2000,
    this.readMore = true,
    this.javascriptChannels = const {},
    this.needHorizotalGestureRecognizer = false,
  }) : super(key: key);

  WebViewController? webViewController;
  final String htmlString;
  final double extraHeight;
  final String? headElements;
  final String? scripts;
  final String? bodyBgColor;
  final Function? updatedHeight;
  final Function? updateWebViewObject;
  final Function? eventCallBack;
  final double? fixedHeight;
  final double maxHeight;
  final bool readMore;
  final Set<Map<String, dynamic>> javascriptChannels;
  final bool? needHorizotalGestureRecognizer;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  // ignore: unused_field
  WebViewController? _webViewController;
  double intialHeight = 1;
  double webviewActualHeight = 0;

  String stylesheetUrl = dotenv.env['WEBVIEW_CSS_URL'] ?? "";

  @override
  void didUpdateWidget(covariant CustomWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_webViewController != null) {
      if (oldWidget.htmlString != widget.htmlString) {
        _webViewController!
            .loadHtmlString(getHtmlTemplate(widget.htmlString, stylesheetUrl, widget.headElements, widget.scripts, widget.bodyBgColor));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Set<Factory<OneSequenceGestureRecognizer>> getGestureRecognizer() {
    if (!widget.readMore) {
      return ({}..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())));
    }

    if (widget.readMore && widget.needHorizotalGestureRecognizer == true) {
      return ({}..add(Factory<HorizontalDragGestureRecognizer>(() => HorizontalDragGestureRecognizer())));
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.fixedHeight ?? intialHeight + widget.extraHeight,
          child: WebView(
            zoomEnabled: false,
            backgroundColor: Colors.transparent,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController!
                  .loadHtmlString(getHtmlTemplate(widget.htmlString, stylesheetUrl, widget.headElements, widget.scripts, widget.bodyBgColor));
              if (widget.updateWebViewObject != null) {
                widget.updateWebViewObject!(_webViewController);
              }
            },
            gestureRecognizers: getGestureRecognizer(),
            javascriptMode: JavascriptMode.unrestricted,
            gestureNavigationEnabled: true,
            javascriptChannels: {
              JavascriptChannel(
                name: "HeightHandler",
                onMessageReceived: (JavascriptMessage message) async {
                  if (widget.fixedHeight == null) {
                    double height = double.parse(message.message);
                    height = height > widget.maxHeight ? widget.maxHeight : height;
                    if (mounted) {
                      setState(() {
                        intialHeight = height;
                        webviewActualHeight = double.parse(message.message);
                      });
                    }
                    if (widget.updatedHeight != null) {
                      widget.updatedHeight!(height);
                    }
                  }
                },
              ),
              ...(widget.javascriptChannels.map((e) {
                return JavascriptChannel(
                    name: e["name"],
                    onMessageReceived: (JavascriptMessage message) {
                      e["callback"](message, false);
                    });
              })),
            },
          ),
        ),
        (widget.readMore && (webviewActualHeight > widget.maxHeight))
            ? Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: InkWell(
                  onTap: () {
                    showReadMoreDailog();
                  },
                  child: Container(
                    height: 50.h,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.white12,
                          Colors.white,
                          Colors.white,
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 5.h),
                      child: Text(
                        'READ MORE',
                        style: textTitle14BoldStyle.merge(
                          const TextStyle(
                            color: colorBlueDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  showReadMoreDailog() {
    showDialog(
      context: context,
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Read More",
                              style: textTitle20WhiteBoldStyle.merge(
                                const TextStyle(
                                  color: colorHeaderTextColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.w),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.cancel,
                                  color: colorBlueDark,
                                  size: 28.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: CustomWebView(
                          htmlString: widget.htmlString,
                          headElements: widget.headElements,
                          readMore: false,
                          scripts: widget.scripts,
                          bodyBgColor: 'white',
                          javascriptChannels: widget.javascriptChannels.map((e) {
                            return {
                              "name": e["name"],
                              "callback": (JavascriptMessage message, bool fromPopup) {
                                e["callback"](message, true);
                              }
                            };
                          }).toSet(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
