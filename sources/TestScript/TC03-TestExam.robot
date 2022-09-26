*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC03-TestExam.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/TestExam?idSubject=%E0%B8%8431101&idLesson=1&idStudent=4003&idExam=9&idQuestion=10
${TIME_WAIT}         5s

*** Test Cases ***
Test03_TestExam
    Begin Webpage
    Login Page  TUPSRB4003   1234
    Open Excel Document     TestData//TC03_TestExam.xlsx     doc_id=TestData
    ${TestExam}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${TestExam.max_row+1}
              Go to  ${TestExam URL} 
              ${ArticleNo1}        Set Variable if    '${TestExam.cell(${i},2).value}'=='None'    ${Empty}     ${TestExam.cell(${i},2).value}
              ${ArticleNo2}        Set Variable if    '${TestExam.cell(${i},3).value}'=='None'    ${Empty}     ${TestExam.cell(${i},3).value}
              ${ArticleNo3}        Set Variable if    '${TestExam.cell(${i},4).value}'=='None'    ${Empty}     ${TestExam.cell(${i},4).value}
              ${ArticleNo4}        Set Variable if    '${TestExam.cell(${i},5).value}'=='None'    ${Empty}     ${TestExam.cell(${i},5).value}
              ${ArticleNo5}        Set Variable if    '${TestExam.cell(${i},6).value}'=='None'    ${Empty}     ${TestExam.cell(${i},6).value}
              ${ArticleNo6}        Set Variable if    '${TestExam.cell(${i},7).value}'=='None'    ${Empty}     ${TestExam.cell(${i},7).value}
              ${ArticleNo7}        Set Variable if    '${TestExam.cell(${i},8).value}'=='None'    ${Empty}     ${TestExam.cell(${i},8).value}
              ${ArticleNo8}        Set Variable if    '${TestExam.cell(${i},9).value}'=='None'    ${Empty}     ${TestExam.cell(${i},9).value}
              ${ArticleNo9}        Set Variable if    '${TestExam.cell(${i},10).value}'=='None'    ${Empty}     ${TestExam.cell(${i},10).value}
              ${ArticleNo10}        Set Variable if    '${TestExam.cell(${i},11).value}'=='None'    ${Empty}     ${TestExam.cell(${i},11).value}

        
                TestExam Page    ${ArticleNo_1}   ${ArticleNo_2}   ${ArticleNo_3}   ${ArticleNo_4}   ${ArticleNo_5}    ${ArticleNo_6}   ${ArticleNo_7}   ${ArticleNo_8}   ${ArticleNo_9}   ${ArticleNo_10}
                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${TestExam.max_row}    Check Error page     ${TestExam.cell(${i},3).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${TestExam.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${TestExam.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${TestExam.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    12       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    13       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC03_TestExam_result.xlsx
    Close All Excel Documents
    Close All Browsers

*** Keywords ***
Begin Webpage
        Open Browser                ${URL}     ${BROWSER}
        Maximize Browser Window
        Set Selenium Speed          0.3s

Login Page
    [Arguments]     ${user}         ${password}
    Input Text      //input[@id='login']    ${user}
    Input Text      //input[@id='password']    ${password}
    Click Element   //body/div[1]/div[1]/form[1]/input[3] 


TestExam Page
    [Arguments]   ${ArticleNo1}   ${ArticleNo2}   ${ArticleNo3}   ${ArticleNo4}   ${ArticleNo5}    ${ArticleNo6}   ${ArticleNo7}   ${ArticleNo8}   ${ArticleNo9}   ${ArticleNo10}

    Select Radio Button  choice1  ${ArticleNo1}
    Select Radio Button  choice2  ${ArticleNo2}
    Select Radio Button  choice3  ${ArticleNo3}
    Select Radio Button  choice4  ${ArticleNo4}
    Select Radio Button  choice5  ${ArticleNo5}
    Select Radio Button  choice6  ${ArticleNo6}
    Select Radio Button  choice7  ${ArticleNo7}
    Select Radio Button  choice8  ${ArticleNo8}
    Select Radio Button  choice9  ${ArticleNo9}
    Select Radio Button  choice10  ${ArticleNo10}

    
    Click Element     //body/form[1]/div[1]/input[6]

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "ส่งคำตอบสำเร็จ"     "ส่งคำตอบไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




