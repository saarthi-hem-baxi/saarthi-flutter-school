import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/connectivity.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/const.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class NoInternetConnection extends StatefulWidget {
  final ConnectivityHandler connectivityHandler;
  const NoInternetConnection({
    Key? key,
    required this.connectivityHandler,
  }) : super(key: key);

  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: getScreenWidth(context),
                  height: getScrenHeight(context) / 2.5,
                  margin:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 50),
                  child: SvgPicture.asset(
                    imageAssets + 'nointernet.svg',
                    allowDrawingOutsideViewBox: true,

                    // fit: BoxFit.f,
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Oops...\n No Internet Connection",
                    textAlign: TextAlign.center,
                    style: textTitle20WhiteBoldStyle
                        .merge(const TextStyle(color: sectionTitleColor)),
                  ),
                ),
                Container(
                  alignment: AlignmentDirectional.center,
                  margin: const EdgeInsets.only(top: 15),
                  child: Text(
                    "Please check your data connection and try again.",
                    textAlign: TextAlign.center,
                    style: textTitle14BoldStyle
                        .merge(const TextStyle(color: colorBodyText)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
