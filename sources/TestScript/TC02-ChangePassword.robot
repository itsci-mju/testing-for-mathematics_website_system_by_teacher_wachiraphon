*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC02-ChangePassword.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/ChangePassword
${TIME_WAIT}         5s

*** Test Cases ***
Test02_ChangePassword
    Begin Webpage
    Login Page  TUPSRB4002   B12345
    Open Excel Document     TestData//TC02_ChangePassword.xlsx     doc_id=TestData
    ${ChangePassword}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${ChangePassword.max_row+1}
              Go to  ${ChangePassword URL} 
              ${oldPassword}        Set Variable if    '${ChangePassword.cell(${i},2).value}'=='None'    ${Empty}     ${ChangePassword.cell(${i},2).value}
              ${newPassword}        Set Variable if    '${ChangePassword.cell(${i},3).value}'=='None'    ${Empty}     ${ChangePassword.cell(${i},3).value}
              ${confirmPassword}    Set Variable if    '${ChangePassword.cell(${i},4).value}'=='None'    ${Empty}     ${ChangePassword.cell(${i},4).value}
        
              ChangePassword Page      ${oldPassword}      ${newPassword}      ${confirmPassword}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${ChangePassword.max_row}    Check Error page     ${ChangePassword.cell(${i},5).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${ChangePassword.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${ChangePassword.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${ChangePassword.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    6       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    7       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC02_ChangePassword_result.xlsx
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


ChangePassword Page
    [Arguments]   ${passwords}    ${newpasswords}     ${confirmpassword}
    Input Text      //input[@id='passwords']         ${passwords}
    Input Text      //input[@id='newpassword']       ${newpasswords}
    Input Text      //input[@id='confirmpassword']   ${confirmpassword}
    Click Element   //input[@id='register-submit']

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "แก้ไขรหัสผ่านสำเร็จ"     "แก้ไขรหัสผ่านไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




