import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:saarthi_pedagogy_studentapp/model/lessplan/lesson_plan.dart';
import 'package:saarthi_pedagogy_studentapp/screen/lesson_plan_word_view.dart';

import '../../helpers/utils.dart';
import '../../screen/lesson_plan.dart';
import '../../theme/colors.dart';
import '../../theme/style.dart';

class WordSection extends StatelessWidget {
  const WordSection({
    Key? key,
    required this.lessonPlanModal,
    required this.lessonPlan,
    required this.type,
    required this.id,
    required this.subjectId,
    required this.chapterId,
  }) : super(key: key);

  final LessonPlanListModal? lessonPlanModal;
  final LessonPlan? lessonPlan;
  final LPQBType type;
  final String id;
  final String subjectId;
  final String chapterId;

  bool isShowWord(Word word) {
    if (type == LPQBType.topic) {
      if (lessonPlan?.isPublisher == true) {
        int index = (word.topics ?? []).indexWhere((element) => element.topic == id);
        if (index != -1) {
          return true;
        }
      } else {
        //for when lesson plan is saarthi's lesson plan
        for (var concept in word.concepts ?? []) {
          bool isContainInGlobalConcepts = (lessonPlanModal?.concepts ?? []).contains(concept);
          if (isContainInGlobalConcepts) {
            return true;
          }
        }
      }
      return false;
    } else {
      bool isContain = (word.concepts ?? []).contains(id);
      return isContain;
    }
  }

  bool isShowWordCard() {
    bool show = false;
    for (var word in lessonPlan?.words ?? []) {
      if (isShowWord(word)) {
        show = true;
        break;
      }
    }
    return show;
  }

  String get lang => lessonPlanModal?.lang ?? "";

  List<Word> getData(List<Word> data) {
    return data
        .where(
            (element) => (element.lang ?? []).contains(lang) && element.word?.containsKey(lang) == true && (element.word?[lang]?.isNotEmpty ?? false))
        .toList();
  } // get word where word's language are contains lessonplan language also word's contains lessonplan language

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ((lessonPlan?.words ?? []).isNotEmpty)
            ? Container(
                width: getScreenWidth(context),
                padding: isShowWordCard() ? const EdgeInsets.all(15) : EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isShowWordCard()
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            width: getScreenWidth(context),
                            child: Text(
                              "Word",
                              style: textTitle16WhiteBoldStyle.merge(
                                const TextStyle(color: sectionTitleColor),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: getData(lessonPlan?.words ?? []).map<Widget>(
                              (word) {
                                if (isShowWord(word)) {
                                  return GestureDetector(
                                    onTap: () => {
                                      showDialog(
                                        context: context, // <<----
                                        barrierDismissible: false,
                                        builder: (BuildContext dc) {
                                          return LessonPlanWordViewPage(
                                            title: "",
                                            word: word,
                                            dialogContext: dc,
                                            lessonPlan: lessonPlan,
                                            type: type,
                                            id: id,
                                            subjectId: subjectId,
                                            chapterId: chapterId,
                                          );
                                        },
                                      )
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                        right: 10.w,
                                        top: 5.h,
                                        bottom: 5.h,
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                        color: colorPinkLight,
                                      ),
                                      child: Text(
                                        word.word?[lang] ?? "",
                                        style: textTitle14BoldStyle.merge(
                                          const TextStyle(
                                            color: colorPink,
                                          ),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : null);
  }
}
