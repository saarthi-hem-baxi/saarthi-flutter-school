import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'strings.dart';

String getExamWebViewBaseString({
  required String questionString,
  required String questionId,
  required bool isMcqBasedQuestion,
  required List<String> mcqOptions,
  bool isShowHint = false,
  bool isShowSolutionBtn = false,
  bool? isAnsSubmitted,
  List<int?>? correntAnsIndexes,
  int? wrongAnsIndex,
  int? userSelectedIndex,
}) {
  return '''<div id="content" class="question-wrap bg-transparent"> 
        ${getExamWebViewQuestionString(questionString, questionId, isShowHint)}
        ${isMcqBasedQuestion ? getExamWebViewMCQString(
          mcqs: mcqOptions,
          questionId: questionId,
          correntAnsIndexes: correntAnsIndexes,
          wrongAnsIndex: wrongAnsIndex,
          isAnsSubmitted: isAnsSubmitted,
          userSelectedIndex: userSelectedIndex,
          isShowSolutionBtn: isShowSolutionBtn,
        ) : getExamWebViewTrueFalseString(
          questionId: questionId,
          isAnsSubmitted: isAnsSubmitted,
          correntAnsIndexes: correntAnsIndexes,
          wrongAnsIndex: wrongAnsIndex,
          userSelectedIndex: userSelectedIndex,
          isShowSolutionBtn: isShowSolutionBtn,
        )}        
    </div>''';
}

String getExamWebViewStyling() {
  return ''' <style>
      body {
        margin: 0;
        font-size: 14px;
        line-height: 19px;
        color: #444444;
        font-family: "Nunito", sans-serif;
      }
      .white-curv-block {
        background: #ffffff;
        box-shadow: 0px 2px 5px rgba(142, 142, 142, 0.1);
        border-radius: 14px;
        padding: 10px 20px;
      }
      .text-purpal {
        color: #4d1877;
      }
      .question-text p {
        padding : 0px;
        margin : 0px;
        line-height: 1.3;
      }
      .text-purpal-btn {
        display : inline-block;
        margin-left: auto;
        margin-right : auto;
        margin-bottom : 0px;
        color: #4d1877;        
        padding : 2px 4px 2px 4px !important;
        background : #F5EDFD;
        border-radius : 4px;
        font-weight :bold;
      }
      .question-wrap {
        padding: 16px;
        background: #faf9fb;
      }
      .mb-0 {
        margin-bottom: 0;
      }
      .mt-0 {
        margin-top: 0;
      }
      .fw-600 {
        font-weight: 600;
      }
      .mb-30 {
        margin-bottom: 30px;
      }
      .mb-16 {
        margin-bottom: 16px;
      }
      .question-wrap .question-option {
        list-style: none;
        padding-left: 0;
        position: relative;
      }
      .flex-colunm {
        flex-direction: column;
      }
      /* new  start */
      .question-wrap .question-option .question-option-li {
        background: #ffffff;
        box-shadow: 0px 2px 5px rgb(142 142 142 / 10%);
        border-radius: 10px;
        padding: 12px 10px 11px 56px;
        margin-bottom: 5px;
        position: relative;
        list-style: none;
        counter-increment: listStyle;
        color: #444;
        font-weight: 600;
        border: transparent solid 2px;
        cursor: pointer;
        -webkit-tap-highlight-color: rgba(0,0,0,0);
      }
      .question-wrap .question-option .question-option-li .que-type {
        border-radius: 50%;
        width: 26px;
        height: 26px;
        position: absolute;
        left: 18px;
        top: 9px;
        background-color: #e7f7fe;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 16px;
        line-height: 18px;
        font-weight: 700;
        color: #0c9fda;
      }
      .question-wrap .question-option .question-option-li.active .que-type {
        background-color: #ac48ea;
        color: #fff;
      }
      .question-wrap .question-option .question-option-li .question-left {
        flex: 1;
        margin-right: 10px;
      }
      .question-wrap .question-option .question-option-li.correct {
        border: #79ce4b solid 2px;
      }
      .question-wrap .question-option .question-option-li.wrong {
        border: #eb4747 solid 2px;
      }

      .question-wrap .question-option  .question-option-li.active {
        border: #ac48ea solid 2px;
      }
      .question-action-icon {
        display: none;
      }

      .true-active {
        border: #ac48ea solid 0px;
      }

      .false-active {
        border: #ac48ea solid 0px;
      }

      .question-action-icon .material-icons {
        background-color: transparent;
        border-radius: 50%;
        color: #000;
        width: 15px;
        height: 15px;
        display: inline-flex;
        justify-content: center;
        align-items: center;
        font-size: 12px;
        line-height: inherit;
      }
      .question-action-icon.wrong .material-icons {
        background-color: #eb4747 !important;
        color: #fff;
      }

      .question-action-icon.correct .material-icons {
        background-color: #79ce4b !important;
        color: #fff;
      }

	    .QueRadiobtn.correct .question-action-icon.correct {
        display: block;
      }
      .QueRadiobtn.wrong .question-action-icon.wrong {
        display: block;
      }


      .question-wrap
        .question-option
        .question-option-li.correct
        .question-action-icon.correct {
        display: block;
      }
      .question-wrap
        .question-option
        .question-option-li.wrong
        .question-action-icon.wrong {
        display: block;
      }
      .QueRadiobtn input + label .question-action-icon .material-icons {
        background-color: #eb4747;
        color: #fff;
      }

      .QueRadiobtn input:checked + label .question-action-icon .material-icons {
        background-color: #79ce4b;
        color: #fff;
      }
      .view-solution-btn {
        background-color: #fff;
        border-radius: 10px;
        padding: 0.25rem 0.75rem;
        color: #50982a;
        font-size: 12px;
        font-weight: 600;
        font-family: "Nunito", sans-serif;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        line-height: initial;
        margin-bottom: 10px;
        cursor: pointer;
        transition: color 0.2s ease-in-out, background-color 0.2s ease-in-out;
      }
      .view-solution-btn i {
        font-size: 12px;
        line-height: inherit;
        color: #50982a;
        margin-left: 5px;
        transition: color 0.3s ease-in-out;
      }
      .mb-10 {
        margin-bottom: 10px;
      }
      .mb-5 {
        margin-bottom: 5px;
      }
      /* new end */
      .question-wrap .question-option li.active {
        border: #ac48ea solid 2px;
      }
      .question-wrap .question-option li.active:before {
        background: #cb8cf2;
        background: linear-gradient(180deg, #cb8cf2 0%, #ac47eb 100%);
        color: #fff;
      }
      .question-wrap .question-option li:last-child {
        margin-bottom: 0;
      }
      .qustion-radio-option .white-curv-block {
        min-height: 26px;
        display: flex;
        align-items: center;
      }
      /* changed 6-2-2023 */
      .qustion-radio-option .white-curv-block label {
        text-transform: uppercase;
        color: #000;
        font-weight: 400;
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex: 1;
      }
      /* changed 6-2-2023 */
      .QueRadiobtn {
        position: relative;
        padding-left: 52px;
      }
      .QueRadiobtn input {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        -webkit-appearance: none;
        appearance: none;
      }
      .QueRadiobtn label:after {
        content: "";
        width: 14px;
        height: 14px;
        border-radius: 50%;
        background-color: #fff;
        position: absolute;
        top: 50%;
        left: 25px;
        border: #AC48EA solid 2px;
        transform: translateY(-50%);
      }
      .QueRadiobtn label:before {
        content: "";
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: #AC48EA;
        position: absolute;
        top: 50%;
        left: 29px;
        display: none;
        transform: translateY(-50%);
        z-index: 1;
      }
      .QueRadiobtn input:checked + label::before {
        display: block;
      }

      /* new css */
      .info-icon {
        color: #0c9fda;
        font-size: 18px;
      }
      .dflex {
        display: flex;
      }
      .justify-end {
        justify-content: end;
      }
      .space-between {
        justify-content: space-between;
      }
      .question-text {
        word-wrap: break-word;
        word-break: break-word;
      }
      .question-text *:first-child {
        margin-top: 0;
        margin-bottom: 0;
      }
      .horizontal-scroll {
        overflow: auto;
      }
      .mr-5 {
        margin-right: 5px;
      }
      .hint-icon {
        color: #E7BC04;
        font-size: 18px;
        margin-right : 8px !important;
      }
      .icon-group {
        display :inline-flex;        
        top : 25px;
        right : 25px;
      }
      .qustion-radio-option .white-curv-block {
        min-height: 26px;
        display: flex;
        align-items: center;
        border: transparent solid 2px;
      }
      .qustion-radio-option .white-curv-block.active {
        border-color: #AC48EA;
      }
      .qustion-radio-option .white-curv-block.wrong {
        border-color: #EB4747;
      }
      .qustion-radio-option .white-curv-block.correct {
        border-color: #50982A;
      }
      .correctGroup {
        border: 1px solid #667085;
        padding: 10px 10px 0 10px;
        border-radius: 10px;
        margin-bottom: 5px;
        background: white
      }
      .question-img-scroll {
        width: fit-content;
      }
      .horizontal-scroll {
        overflow : auto
      }
      .bg-transparent {        
        background-color : rgba(0,0,0,0) !important;
      }
      
    </style>''';
}

String getExamWebViewScripting() {
  return '''
    <script>
      let Queoption = document.querySelectorAll(".question-option-click");
      for (let i = 0, length = Queoption.length; i < length; i++) {
        Queoption[i].onclick = function () {
          let queLi = document.querySelector(".question-option-li.active");
          if (queLi) queLi.classList.remove("active");
          this.classList.add("active");
          OptionsAnswer.postMessage(i);
          console.log("index",i)
        };
      }
      const radioBtn = document.querySelectorAll(".QueRadiobtn");
      for (const radioBtns of radioBtn) {
        radioBtns.addEventListener("change", showSelected);
      }
      function showSelected(e) {
        let rdInput = document.querySelector(".QueRadiobtn.active");
        if (rdInput) rdInput.classList.remove("active");
        this.classList.add("active");
      }
      function onTrueFalseClick(index){
        console.log("true false index",index)
        OptionsAnswer.postMessage(index);
      }
      function HintHandlerJS(questionId){
        HintHandler.postMessage(questionId);
      }
      function openViewSolution(questionId){
        console.log("openViewSolution press",questionId);
        SolutionHandler.postMessage(questionId);
      }  
    </script>''';
}

String getExamWebViewQuestionString(String questionString, String questionId, bool isShowHint) {
  String hintIcon = '${dotenv.env['STATIC_ASSETS']}assets%2Fyellow-bulb-icon.svg';
  return '''
    
      <div class="white-curv-block mb-30">
        <div class="dflex space-between">
          <div class="question-text horizontal-scroll mr-5">
            <p class="text-purpal-btn fw-700">
            Q. 
            </p>
            <div style="margin-top:10px">
            $questionString          
            </div>
          </div>
          <div class='icon-group'>
              ${isShowHint ? '''<i class="mr-5" onclick="HintHandlerJS('$questionId')"><img src="$hintIcon" alt="tips-icon" ></i>''' : ''}
              <i class="material-icons info-icon" onclick="handleOnReport('question',['question','$questionId'])">info</i>
          </div>
        </div>
      </div>
    ''';
}

bool isCorrectOption({required List<int?>? correctAnsIndexes, required int? optionIndex}) {
  return (correctAnsIndexes ?? []).contains(optionIndex);
}

String getExamWebViewMCQString({
  required List<String> mcqs,
  required String questionId,
  bool? isAnsSubmitted,
  List<int?>? correntAnsIndexes,
  int? wrongAnsIndex,
  int? userSelectedIndex,
  bool? isShowSolutionBtn,
}) {
  String string = '';
  String wrongAnsString = '';
  String remainOptionsString = '';
  int index = 0;
  for (var item in mcqs) {
    // int index = mcqs.indexOf(item);
    String trimString = item.trim();
    if (isAnsSubmitted == false || correntAnsIndexes?.length == 1) {
      string = string +
          '''
        <div value=$index class='dflex mb-10 flex-colunm'>
          <!-- wrong class for incorrect ans -->
          <div class="question-option-li  horizontal-scroll dflex  ${isAnsSubmitted == true && isCorrectOption(correctAnsIndexes: correntAnsIndexes, optionIndex: index) ? 'correct' : ''} ${isAnsSubmitted == true && wrongAnsIndex == index && userSelectedIndex == index ? 'wrong' : ''} ${isAnsSubmitted == true ? '' : 'question-option-click'}">
            <div class="question-left">
              <div class="que-type">${getAlphabetByIndex(index: index).toUpperCase()}</div>
              <div class="question-text">
                $trimString
              </div>
            </div>
            <div class="question-action-icon wrong">
              <i class="material-icons">close</i>
            </div>
            <div class="question-action-icon correct">
              <i class="material-icons">done</i>
            </div>
          </div>

            ${isAnsSubmitted == true && isShowSolutionBtn == true && isCorrectOption(correctAnsIndexes: correntAnsIndexes, optionIndex: index) && !isCorrectOption(correctAnsIndexes: correntAnsIndexes, optionIndex: userSelectedIndex) ? '''
            <div class="dflex justify-end">
              <div class="view-solution-btn" onclick="openViewSolution('$questionId')">View Solution <i class="material-icons">arrow_forward</i></div>
            </div>
            ''' : ''}
        </div>
        ''';
    }

    if (correntAnsIndexes?.contains(userSelectedIndex) == false && isAnsSubmitted == true && (correntAnsIndexes ?? []).length > 1) {
      if (isAnsSubmitted == true && (correntAnsIndexes ?? []).contains(index)) {
        string = string +
            '''
            <div value=$index class="dflex mb-10 flex-colunm">
              <div class="question-option-li  horizontal-scroll dflex correct ${isAnsSubmitted == true ? '' : 'question-option-click'}">
                <div class="question-left">
                  <div class="que-type">${getAlphabetByIndex(index: index).toUpperCase()}</div>
                  <div class="question-text horizontal-scroll">
                    <div class="question-img-scroll">
                      $trimString
                    </div>
                  </div>
                </div>
                <div class="question-action-icon wrong">
                  <i class="material-icons">close</i>
                </div>
                <div class="question-action-icon correct">
                  <i class="material-icons">done</i>
                </div>                
              </div>
            </div>''';
      } else if (isAnsSubmitted == true && wrongAnsIndex == index) {
        wrongAnsString = '''
      <div class="dflex mb-10 flex-colunm" >
          <div value=$index class="question-option-li  horizontal-scroll dflex wrong ${isAnsSubmitted == true ? '' : 'question-option-click'}">
            <div class="question-left">
              <div class="que-type">${getAlphabetByIndex(index: index).toUpperCase()}</div>
              <div class="question-text">
                <div class="question-img-scroll">
                  $trimString
                </div>
              </div>
            </div>
            <div class="question-action-icon wrong">
              <i class="material-icons">close</i>
            </div>
            <div class="question-action-icon correct">
              <i class="material-icons">done</i>
            </div>
          </div>
        </div>''';
      } else if (isAnsSubmitted == true) {
        // display remaining options
        remainOptionsString = '''
        <div class="dflex mb-10 flex-colunm" >
          <div class="question-option-li  horizontal-scroll dflex ${isAnsSubmitted == true ? '' : 'question-option-click'}">
            <div class="question-left">
              <div class="que-type">${getAlphabetByIndex(index: index).toUpperCase()}</div>
              <div class="question-text horizontal-scroll">
                <div class="question-img-scroll">
                  $trimString
                </div>
              </div>
            </div>
            <div class="question-action-icon wrong">
              <i class="material-icons">close</i>
            </div>
            <div class="question-action-icon correct">
              <i class="material-icons">done</i>
            </div>
          </div>
        </div>''';
      }
    } else if (isAnsSubmitted == true && (correntAnsIndexes ?? []).length > 1) {
      string = string +
          '''

        <div class="dflex mb-10 flex-colunm">
          <div value=$index  class="question-option-li  horizontal-scroll dflex ${isAnsSubmitted == true && isCorrectOption(correctAnsIndexes: correntAnsIndexes, optionIndex: index) && userSelectedIndex == index ? 'correct' : ''}  ${isAnsSubmitted == true ? '' : 'question-option-click'}">
            <div class="question-left">
              <div class="que-type">${getAlphabetByIndex(index: index).toUpperCase()}</div>
              <div class="question-text horizontal-scroll" >
                <div class="question-img-scroll">
                  $trimString
                </div>
              </div>
            </div>
            <div class="question-action-icon wrong">
              <i class="material-icons">close</i>
            </div>
            <div class="question-action-icon correct">
              <i class="material-icons">done</i>
            </div>
          </div>
        </div>
        ''';
    }
    index = index + 1;
  }

  if ((correntAnsIndexes ?? []).length > 1 &&
      isAnsSubmitted == true &&
      wrongAnsIndex != null &&
      !(correntAnsIndexes ?? []).contains(userSelectedIndex)) {
    string = '''<div class="correctGroup"> $string </div> 
                <div class="dflex justify-end">
                  ${isShowSolutionBtn == true ? '''<div class="view-solution-btn" onclick="openViewSolution('$questionId')">View Solution <i class="material-icons">arrow_forward</i></div>''' : ''}  
                </div>
             ''';
  }

  return '''<div class="question-option">
            <div class="correctGroup-parent">
              $wrongAnsString
              $string
              $remainOptionsString
            </div>
        </div>''';
}

String getExamWebViewTrueFalseString(
    {required String questionId,
    required bool? isAnsSubmitted,
    required List<int?>? correntAnsIndexes,
    required int? wrongAnsIndex,
    int? userSelectedIndex,
    bool? isShowSolutionBtn}) {
  return '''
      <div class="qustion-radio-option" id="qustion-radio-option" >
        <div class="dflex mb-10 flex-colunm qustion-radio-option-wrapper">
          <div style="${isAnsSubmitted == true ? 'pointer-events: none;' : ''}" class="white-curv-block mb-5 QueRadiobtn  ${isAnsSubmitted == true && (correntAnsIndexes ?? [])[0] == 0 ? 'correct' : ''} ${isAnsSubmitted == true && (correntAnsIndexes ?? [])[0] == 1 && userSelectedIndex != (correntAnsIndexes ?? [])[0] ? 'wrong' : ''} " onclick="onTrueFalseClick(0)">
            <input type="radio" name="question" id="queTrue" ${isAnsSubmitted == true && userSelectedIndex == 0 ? 'checked' : ''} ${isAnsSubmitted == true ? 'disabled' : ''} />
            <label for="queTrue"
              >True 
              <div class="question-action-icon wrong">
                <i class="material-icons">close</i>
              </div>
              <div class="question-action-icon correct">
                <i class="material-icons">done</i>
              </div>
            </label>
          </div>
          ${isAnsSubmitted == true && isShowSolutionBtn == true && (correntAnsIndexes ?? [])[0] == 0 && userSelectedIndex != (correntAnsIndexes ?? [])[0] ? '''
    
            <div class="dflex justify-end">
              <div class="view-solution-btn" onclick="openViewSolution('$questionId')">View Solution <i class="material-icons">arrow_forward</i></div>
            </div>

            ''' : ''}
        </div>

        <div class="dflex mb-10 flex-colunm"> 
          <div style="${isAnsSubmitted == true ? 'pointer-events: none;' : ''}" class="white-curv-block QueRadiobtn  ${isAnsSubmitted == true && (correntAnsIndexes ?? [])[0] == 1 ? 'correct' : ''} ${isAnsSubmitted == true && (correntAnsIndexes ?? [])[0] == 0 && userSelectedIndex != (correntAnsIndexes ?? [])[0] ? 'wrong' : ''}" onclick="onTrueFalseClick(1)">
            <input type="radio" name="question" id="queFalse" ${isAnsSubmitted == true && userSelectedIndex == 1 ? 'checked' : ''} ${isAnsSubmitted == true ? 'disabled' : ''}  />
            <label for="queFalse"
              >False
              <div class="question-action-icon wrong">
                <i class="material-icons">close</i>
              </div>
              <div class="question-action-icon correct">
                <i class="material-icons">done</i>
              </div>
            </label>
          </div>
          ${isAnsSubmitted == true && isShowSolutionBtn == true && (correntAnsIndexes ?? [])[0] == 1 && userSelectedIndex != (correntAnsIndexes ?? [])[0] ? '''
            <div class="dflex justify-end" style="margin-top:10px">
              <div class="view-solution-btn" onclick="openViewSolution('$questionId')" >View Solution <i class="material-icons">arrow_forward</i></div>
            </div>
            ''' : ''}
        </div>                
        </div>               
      </div>''';
}
