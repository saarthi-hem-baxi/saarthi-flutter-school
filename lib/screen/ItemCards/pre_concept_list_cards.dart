import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import 'package:saarthi_pedagogy_studentapp/model/precap_model/pre_concept.dart';

import '../../theme/colors.dart';
import '../../theme/style.dart';

class PrecapConceptListItem extends StatelessWidget {
  final PreConcept preConceptData;
  const PrecapConceptListItem({
    Key? key,
    required this.preConceptData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
      width: getScreenWidth(context),
      decoration: boxDecoration14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            preConceptData.concept?.name?.enUs?.toString() ?? "",
            style: sectionTitleTextStyle.merge(
              const TextStyle(fontSize: 16, color: colorWebPanelDarkText),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              direction: Axis.horizontal,
              // alignment: WrapAlignment.center,
              runSpacing: 5,
              children: preConceptData.keyLearnings!
                  .map(
                    (keyLearningData) => Container(
                      margin: const EdgeInsets.only(top: 5, right: 7),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(14),
                        ),
                        color: keyLearningData.cleared != null
                            ? keyLearningData.cleared!
                                ? colorGreenLight
                                : colorRedLight
                            : colorgray249,
                      ),
                      child: Text(
                        keyLearningData.keyLearning?.name?.enUs.toString() ?? "",
                        style: textTitle12BoldStyle.merge(TextStyle(
                            color: keyLearningData.cleared != null
                                ? keyLearningData.cleared!
                                    ? colorGreen
                                    : colorRed
                                : colorBodyText,
                            fontWeight: FontWeight.normal)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
