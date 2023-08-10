import 'package:flutter/material.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';

import '../../model/system_generated_test_model/selfautohw/unclear_pre_concepts.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class SelfConceptListItem extends StatelessWidget {
  final UnclearPreConcepts conceptData;
  const SelfConceptListItem({
    Key? key,
    required this.conceptData,
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
            conceptData.preConcept?.name?.enUs ?? "",
            style: sectionTitleTextStyle.merge(
              const TextStyle(fontSize: 16, color: colorWebPanelDarkText),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Wrap(
              direction: Axis.horizontal,
              // alignment: WrapAlignment.center,
              runSpacing: 5,
              children: (conceptData.unclearKeyLearnings ?? [])
                  .map(
                    (keyLearningData) => Container(
                      margin: const EdgeInsets.only(top: 5, right: 7),
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: boxDecoration14,
                      child: Text(
                        keyLearningData.name?.enUs.toString() ?? "",
                        style: textTitle12BoldStyle.merge(
                          const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                        ),
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
