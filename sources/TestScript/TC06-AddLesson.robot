*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC06-AddLesson.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/AddLesson?idSubject=%E0%B8%97%E0%B8%AA333
${TIME_WAIT}         5s

*** Test Cases ***
Test06_AddLesson
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC06_AddLesson.xlsx     doc_id=TestData
    ${AddLesson}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${AddLesson.max_row+1}
              Go to  ${AddLesson URL} 
              ${Lesson_id}        Set Variable if    '${AddLesson.cell(${i},2).value}'=='None'    ${Empty}     ${AddLesson.cell(${i},2).value}
              ${Lesson_name}      Set Variable if    '${AddLesson.cell(${i},3).value}'=='None'    ${Empty}     ${AddLesson.cell(${i},3).value}
              ${fileUpload}       Set Variable if    '${AddLesson.cell(${i},4).value}'=='None'    ${Empty}     ${AddLesson.cell(${i},4).value}
              ${fileVDO}          Set Variable if    '${AddLesson.cell(${i},5).value}'=='None'    ${Empty}     ${AddLesson.cell(${i},5).value}
              ${Lesson_details}   Set Variable if    '${AddLesson.cell(${i},6).value}'=='None'    ${Empty}     ${AddLesson.cell(${i},6).value}
        
              AddLesson Page      ${Lesson_id}      ${Lesson_name}      ${fileUpload}      ${fileVDO}      ${Lesson_details}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${AddLesson.max_row}    Check Error page     ${AddLesson.cell(${i},7).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${AddLesson.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${AddLesson.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${AddLesson.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    8       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    9       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC06_AddLesson_result.xlsx
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


AddLesson Page
    [Arguments]       ${Lesson_id}      ${Lesson_name}      ${fileUpload}      ${fileVDO}      ${Lesson_details}
    Input Text       //input[@id='Lesson_id']            ${Lesson_id}
    Input Text       //input[@id='Lesson_name']          ${Lesson_name}
    Run Keyword If     '${fileUpload}'!=' ${Empty}'     Choose File        id=fileUpload     ${fileUpload}      
    Input Text       //input[@id='fileVDO']              ${fileVDO}
    Input Text       //textarea[@id='Lesson_detail']     ${Lesson_details} 
    Click Element   //body[1]/form[1]/div[1]/input[1]

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "บันทึกข้อมูลสำเร็จ"     "บันทึกข้อมูลไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




