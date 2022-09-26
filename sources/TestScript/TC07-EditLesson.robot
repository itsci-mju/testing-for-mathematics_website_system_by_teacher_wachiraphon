*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC07-EditLesson.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/EditLesson?id=105
${TIME_WAIT}         5s

*** Test Cases ***
TC07-EditLesson
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC07-EditLesson1.xlsx     doc_id=TestData
    ${EditLesson}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${EditLesson.max_row+1}
              Go to  ${EditLesson URL} 
              ${EditLesson_id}        Set Variable if    '${EditLesson.cell(${i},2).value}'=='None'    ${Empty}     ${EditLesson.cell(${i},2).value}
              ${EditLesson_name}      Set Variable if    '${EditLesson.cell(${i},3).value}'=='None'    ${Empty}     ${EditLesson.cell(${i},3).value}
              ${EditfileUpload}       Set Variable if    '${EditLesson.cell(${i},4).value}'=='None'    ${Empty}     ${EditLesson.cell(${i},4).value}
              ${EditfileVDO}          Set Variable if    '${EditLesson.cell(${i},5).value}'=='None'    ${Empty}     ${EditLesson.cell(${i},5).value}
              ${EditLesson_details}   Set Variable if    '${EditLesson.cell(${i},6).value}'=='None'    ${Empty}     ${EditLesson.cell(${i},6).value}
        
              EditLesson Page      ${EditLesson_id}      ${EditLesson_name}      ${EditfileUpload}      ${EditfileVDO}      ${EditLesson_details}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${EditLesson.max_row}    Check Error page     ${EditLesson.cell(${i},7).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${EditLesson.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${EditLesson.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${EditLesson.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    8       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    9       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC07_EditLesson1_result.xlsx
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


EditLesson Page
    [Arguments]       ${EditLesson_id}      ${EditLesson_name}      ${EditfileUpload}      ${EditfileVDO}      ${EditLesson_details}
    Input Text       //body/form[1]/div[1]/input[2]     ${EditLesson_id}
    Input Text       //input[@id='Lesson_name']         ${EditLesson_name}
    Run Keyword If     '${EditfileUpload}'!=' ${Empty}'     Choose File        id=fileUpload     ${EditfileUpload}      
    Input Text       //input[@id='fileVDO']             ${EditfileVDO}
    Input Text       //input[@id='Lesson_detail']       ${EditLesson_details} 
    Click Element    //body/form[1]/div[1]/input[7]

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "บันทึกข้อมูลสำเร็จ"     "บันทึกข้อมูลไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




