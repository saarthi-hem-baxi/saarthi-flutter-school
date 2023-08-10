import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/strings.dart';
import 'package:saarthi_pedagogy_studentapp/helpers/utils.dart';
import '../model/tests_model/hint_solution_model.dart';

String getExamAnswerKeyWebViewString({
  required List<AnswerKeyWebViewStringModal> answerKeyData,
}) {
  return '''<div id="content" class="p-16">
      ${getAnswerKeyString(answerKeyData: answerKeyData)}
    </div>
''';
}

String getExamAnswerKeyWebViewScripting() {
  return '''<script>
    function SolutionHandlerJS(questionIndex){
        SolutionHandler.postMessage(questionIndex);
      }  
    </script>''';
}

String getExamAnswerKeyWebviewStyling() {
  return '''<style>
      body {
        margin: 0 auto;
        font-size: 14px;
        line-height: 19px;
        color: #444444;
      }
      .p-16 {
        padding: 16px;
      }
      .whitebox {
        background: #ffffff;
        box-shadow: 0px 2px 5px rgba(142, 142, 142, 0.1);
        border-radius: 14px;
        padding: 10px 16px 0px 16px;
        margin-bottom: 12px;
      }
      .whitebox div {
        display: flex;
        font-weight: 600;
        font-size: 16px;
        line-height: 1.3;
        color: #444;
        font-family: "Nunito", sans-serif;
        align-items: center;
        margin-top: 0;
        margin-bottom: 12px; 
      }
      .indexLabel {
        border-radius: 50%;
        background-color: #eefcfc;
        width: 22px;
        height: 22px;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #007a7a;
        font-weight: 700;
        font-size: 14px;
        line-height: 18px;
        margin-right: 5px;
      }
      .whitebox div p {
        margin-top: 0;
        margin-bottom: 0;
      }
      .whitebox ol {
        margin-top: 0;
        margin-bottom: 0;
        padding-left: 60px;
      }
      .whitebox ol li {
        position: relative;
        font-size: 14px;
        line-height: 20px;
        color: #808080;
        margin-bottom: 10px;
        font-family: "Nunito", sans-serif;
      }
      .whitebox ol li p {
        margin-top: 0;
        margin-bottom: 0;
      }
      .whitebox ol li::marker {
        color: #444;
      }
      .whitebox ol li:last-child {
        margin-bottom: 0;
      }

      /* new css */
      .whitebox .heading {
        display: flex;
      }
      .whitebox .heading > span {
        border-radius: 50%;
        background-color: #eefcfc;
        width: 22px;
        height: 22px;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #007a7a;
        font-weight: 700;
        font-size: 14px;
        line-height: 18px;
        margin-right: 5px;
        font-family: "Nunito", sans-serif;
      }
      .whitebox .heading .subhead h1,
      .whitebox .heading .subhead h2,
      .whitebox .heading .subhead h3,
      .whitebox .heading .subhead h4,
      .whitebox .heading .subhead h5,
      .whitebox .heading .subhead h6 {
        margin-top: 0;
        font-family: "Nunito", sans-serif;
        color: #444;
        line-height: 1.2;
      }
      .answerlist {
        list-style: none;
        padding-left: 10px;
        margin-top: 5px;
        margin-bottom: 0;
      }
      .answerlist li {
        display: flex;
        align-items: flex-start;
        margin-bottom: 5px;
        font-family: "Nunito", sans-serif;
      }
      .answerlist li .icongroup {
        display: flex;
        margin-right: 5px;
        min-width: 36px;
        justify-content: end;
      }
      .answerlist li .icongroup i {
        display: flex;
        align-items: center;
      }
      .answerlist li .icongroup strong {
        color: #444;
        font-weight: 400;
      }
      .answerlist li p,
      .answerlist li h1,
      .answerlist li h2,
      .answerlist li h3,
      .answerlist li h4,
      .answerlist li h5,
      .answerlist li h6 {
        margin-top: 0;
        margin-bottom: 0;
        color: #808080;
      }
      .mr-10 {
        margin-right: 10px;
      }
      .scrolling {
        overflow : auto;
      }

      .solution-container {
        display : block;
        margin-bottom: 0px !important;
      }

      .solution-heading {
        font-size : 16px;
        color : #4D1877;
        font-weight : bold;
      }

      .solution-body {
        max-height : 95px;
        overflow : auto;
        display: flex !important;
        flex-direction: column;
        align-items: start !important;
      }

      .video-btn-wrapper {
        display: flex;
        align-items: center;
        margin-top : 10px !important; 
        margin-bottom: 0px !important;
      }

      .video-btn {
        margin-left : auto;
        margin-right : auto;
        background: #F5EDFD;
        padding : 5px 15px;
        border-radius : 10px 10px 0px 0px;
        margin-bottom: 0px !important;
      }

      .video-btn span {
        color : #4D1877;
        font-size : 12px;
        font-weight : bold;
        line-height : 16px;
      }

      .m-10{
        margin : 10px;
      }

      .mb-10{
        margin-bottom : 10px;
      }

      .question-wrapper {
        display: flex !important;
        flex-direction: column;
        align-items: start !important;
      }

    </style>''';
}

String getAnswerKeyString({
  required List<AnswerKeyWebViewStringModal> answerKeyData,
}) {
  String string = '';

  int index = 0;
  for (var item in answerKeyData) {
    if (item.isMCQtypeQuestion) {
      string = string +
          getMCQOptionsString(
            index: index + 1,
            question: item.question,
            options: item.mcqOptions,
            isTrueAns: item.isTrueAns ?? false,
            ansOptionIndex: item.ansOptionIndex ?? 0,
            correctOptionIndex: item.correctOptionIndex,
            solution: item.solution,
            userSelectedIndex: item.userSelectedIndex,
          );
    } else {
      string = string +
          getTrueFalseString(
            index: index + 1,
            question: item.question,
            isTrueAns: item.isTrueAns ?? false,
            trueFalseAns: item.trueFalseAns ?? false,
            solution: item.solution,
          );
    }
    index = index + 1;
  }
  return string;
}

String getMCQOptionsString({
  required int index,
  required String question,
  required List<String> options,
  required bool isTrueAns,
  required int ansOptionIndex,
  required List<int?>? correctOptionIndex,
  Solution? solution,
  required int? userSelectedIndex,
}) {
  String optionString = '';

  String verifiedIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fverified-icon.svg';
  String correctIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fcurrect-icon.svg';
  String wrongIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fwrong-icon.svg';

  int itemIndex = 0;
  for (var item in options) {
    String sideIconString = '';

    if (isTrueAns && (correctOptionIndex ?? []).contains(itemIndex) && userSelectedIndex == itemIndex) {
      sideIconString = '''<i class="mr-10"><img src="$verifiedIconUrl" alt="verified-icon" ></i>''';
    } else {
      if ((correctOptionIndex ?? []).contains(itemIndex)) {
        sideIconString = '''<i class="mr-10"><img src="$correctIconUrl" alt="currect-icon" ></i>''';
      }
      if (ansOptionIndex == itemIndex) {
        sideIconString = '''<i class="mr-10"><img src="$wrongIconUrl" ></i>''';
      }
    }
    optionString = optionString +
        '''<li>
            <div class="icongroup">
              $sideIconString
              <strong>${getAlphabetByIndex(index: itemIndex)}.</strong>
            </div>
            <div class="question-wrapper">
            $item
            </div>
          </li>''';
    itemIndex = itemIndex + 1;
  }
  return '''<div class="whitebox scrolling">
        <div>        
          <span class="indexLabel">$index.</span>
          <div class="question-wrapper">
            $question            
          </div>
        </div>
        <ul class="answerlist">
          $optionString
        </ul>
                ${((solution != null && (solution.description?.enUs ?? '').isNotEmpty)) && !isTrueAns ? ''' <div style="display:block">
          <h3 class="solution-heading">Solution</h3>  
          <div class="solution-body" >
            ${solution.description?.enUs ?? ''}
          </div>
        </div>''' : ''}
      
      ${((solution != null && (solution.media ?? []).isNotEmpty)) && !isTrueAns && getfilteredVideoMedia(solutionMedia: solution.media ?? []).isNotEmpty ? '''
        <div class="video-btn-wrapper" onclick="SolutionHandlerJS('${index - 1}')">
          <div class="video-btn">  <span>Video</span> </div>
        </div> ''' : ''}
      </div>''';
}

String getTrueFalseString({
  required int index,
  required String question,
  required bool isTrueAns,
  required bool trueFalseAns,
  Solution? solution,
}) {
  String string = '';

  String verifiedIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fverified-icon.svg';
  String correctIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fcurrect-icon.svg';
  String wrongIconUrl = '${dotenv.env['STATIC_ASSETS']}assets%2Fwrong-icon.svg';

  if (isTrueAns == true && trueFalseAns == true) {
    string = '''<li>
            <div class="icongroup">
              <i class="mr-10"><img src="$verifiedIconUrl" ></i>
              <strong>a.</strong>
            </div>
            <p>TRUE</p>
          </li>
          <li>
            <div class="icongroup">            
              <strong>b.</strong>
            </div>
            <p>FALSE</p>
          </li>''';
  } else if (isTrueAns == true && trueFalseAns == false) {
    string = '''<li>
            <div class="icongroup">
              <strong>a.</strong>
            </div>
            <p>TRUE</p>
          </li>
          <li>
            <div class="icongroup">           
            <i class="mr-10"><img src="$verifiedIconUrl" alt="verified-icon" ></i> 
              <strong>b.</strong>
            </div>
            <p>FALSE</p>
          </li>''';
  } else if (isTrueAns == false && trueFalseAns == true) {
    string = '''<li>
            <div class="icongroup">
              <i class="mr-10"><img src="$correctIconUrl" alt="currect-icon" ></i>
              <strong>a.</strong>
            </div>
            <p>TRUE</p>
          </li>
          <li>
            <div class="icongroup">
              <i class="mr-10"><img src="$wrongIconUrl" alt="wrong-icon" ></i>            
              <strong>b.</strong>
            </div>
            <p>FALSE</p>
          </li>''';
  } else if (isTrueAns == false && trueFalseAns == false) {
    string = '''<li>
            <div class="icongroup">
              <i class="mr-10"><img src="$wrongIconUrl" alt="wrong-icon" ></i>            
              <strong>a.</strong>
            </div>
            <p>TRUE</p>
          </li>
          <li>
            <div class="icongroup">
              <i class="mr-10"><img src="$correctIconUrl" alt="currect-icon" ></i>
              <strong>b.</strong>
            </div>
            <p>FALSE</p>
          </li>''';
  }

  return '''<div class="whitebox scrolling">
        <div>
          <span class="indexLabel">$index.</span>
          <div class="question-wrapper">
            $question
          </div>
        </div>
        <ul class="answerlist">
          $string
        </ul>
        ${((solution != null && (solution.description?.enUs ?? '').isNotEmpty)) && !isTrueAns ? ''' <div style="display:block">
          <h3 class="solution-heading">Solution</h3>  
          <div class="solution-body" >
            ${solution.description?.enUs ?? ''}
          </div>
        </div>''' : ''}
      
      ${((solution != null && (solution.media ?? []).isNotEmpty)) && !isTrueAns && getfilteredVideoMedia(solutionMedia: solution.media ?? []).isNotEmpty ? '''
        <div class="video-btn-wrapper" onclick="SolutionHandlerJS('${index - 1}')">
          <div class="video-btn">  <span>Video</span> </div>
        </div> ''' : ''}
        
      </div>''';
}

class AnswerKeyWebViewStringModal {
  String question;
  bool isMCQtypeQuestion;
  List<String> mcqOptions;
  bool? isCorrectMCQ;
  List<int?>? correctOptionIndex;
  int? ansOptionIndex;
  bool? isTrueAns;
  bool? trueFalseAns;
  Solution? solution;
  int? userSelectedIndex;

  AnswerKeyWebViewStringModal({
    required this.question,
    required this.isMCQtypeQuestion,
    required this.mcqOptions,
    this.isCorrectMCQ,
    this.correctOptionIndex,
    this.ansOptionIndex,
    this.isTrueAns,
    this.trueFalseAns,
    this.solution,
    this.userSelectedIndex,
  });
}
