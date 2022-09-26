*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC09-EditExam.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}                http://localhost:8081/Test_01/EditExam?idExam=9&idQuestion=10
${TIME_WAIT}         5s

*** Test Cases ***
Test09_EditExam
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC09_EditExam.xlsx     doc_id=TestData
    ${EditExam}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${EditExam.max_row+1}
              Go to  ${EditExam URL} 
              ${Edit_question1}  Set Variable if    '${EditExam.cell(${i},2).value}'=='None'    ${Empty}     ${EditExam.cell(${i},2).value}
              ${Edit_choice}     Set Variable if    '${EditExam.cell(${i},3).value}'=='None'    ${Empty}     ${EditExam.cell(${i},3).value}
        
              EditExam Page      ${Edit_question1}      ${Edit_choice} 

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${EditExam.max_row}    Check Error page     ${EditExam.cell(${i},4).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${EditExam.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${EditExam.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${EditExam.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    6       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC09_EditExam_result.xlsx
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


EditExam Page
    [Arguments]   ${Edit_question1}      ${Edit_choice}   
    Input Text           ${question1}                    ${Edit_question1}
    Input Text           ${choice}                       ${Edit_choice}
    
    Click Element   ${btn-record}

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "แก้ไขข้อมูลสำเร็จ"     "แก้ไขข้อมูลไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




