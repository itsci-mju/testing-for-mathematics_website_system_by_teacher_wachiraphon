*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC12-EditStudent.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/EditStudent
${TIME_WAIT}         5s

*** Test Cases ***
Test12_EditStudent
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC12_EditStudent.xlsx     doc_id=TestData
    ${EditStudent}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${EditStudent.max_row+1}
              Go to  ${EditStudent URL} 
              ${Edit_name}        Set Variable if    '${EditStudent.cell(${i},2).value}'=='None'    ${Empty}     ${EditStudent.cell(${i},2).value}
              ${Edit_surname}     Set Variable if    '${EditStudent.cell(${i},3).value}'=='None'    ${Empty}     ${EditStudent.cell(${i},3).value}
              ${Edit_status1}      Set Variable if    '${EditStudent.cell(${i},4).value}'=='None'    ${Empty}     ${EditStudent.cell(${i},4).value}
        
              EditStudent Page      ${Edit_name}      ${Edit_surname}      ${Edit_status1}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${EditStudent.max_row}    Check Error page     ${EditStudent.cell(${i},5).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${EditStudent.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${EditStudent.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${EditStudent.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    6       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    7       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC12_EditStudent_result.xlsx
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


EditStudent Page
    [Arguments]   ${Edit_name}    ${Edit_surname}     ${Edit_status1}
    Input Text      ${name}        ${Edit_name}
    Input Text       ${surname}       ${Edit_surname}
    Select From List By Label      ${status}         ${Edit_status1}
    Click Element   //body[1]/form[1]/div[1]/div[1]/input[33]

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "บันทึกข้อมูลสำเร็จ"     "บันทึกข้อมูลไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




