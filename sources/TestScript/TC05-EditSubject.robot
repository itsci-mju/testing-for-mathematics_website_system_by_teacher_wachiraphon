*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC05-EditSubject.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/EditSubject?id=ค31101
${TIME_WAIT}         5s

*** Test Cases ***
TC05-EditSubject
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC05_EditSubject2.xlsx     doc_id=TestData
    ${EditSubject}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${EditSubject.max_row+1}
              Go to  ${EditSubject URL} 
              ${subject_id}        Set Variable if    '${EditSubject.cell(${i},2).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},2).value}
              ${subject_year}      Set Variable if    '${EditSubject.cell(${i},3).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},3).value}
              ${subject_grades}    Set Variable if    '${EditSubject.cell(${i},4).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},4).value}
              ${subject_terms}     Set Variable if    '${EditSubject.cell(${i},5).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},5).value}
              ${subject_names}     Set Variable if    '${EditSubject.cell(${i},6).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},6).value}
              ${subject_details}   Set Variable if    '${EditSubject.cell(${i},7).value}'=='None'    ${Empty}     ${EditSubject.cell(${i},7).value}
        
            EditSubject Page      ${subject_id}      ${subject_year}      ${subject_grades}        ${subject_terms}      ${subject_names}      ${subject_details}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${EditSubject.max_row}    Check Error page     ${EditSubject.cell(${i},8).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${EditSubject.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${EditSubject.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${EditSubject.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    9       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    10       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC05-EditSubject2_result.xlsx
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


EditSubject Page
    [Arguments]   ${subject_id}      ${subject_year}      ${subject_grades}        ${subject_terms}      ${subject_names}      ${subject_details}
    Input Text      //input[@id='subject_id']             ${subject_id}
    Input Text      //input[@id='subject_year']           ${subject_year}
    Input Text      //input[@id='subject_grade']          ${subject_grades}
    Input Text      //input[@id='subject_term']           ${subject_terms}
    Input Text      //input[@id='subject_name']           ${subject_names}
    Input Text      //textarea[@id='subject_detail']      ${subject_details}
    Click Element   //input[@id='register-submit']

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "แก้ไขบทเรียนสำเร็จ"     "แก้ไขบทเรียนไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




