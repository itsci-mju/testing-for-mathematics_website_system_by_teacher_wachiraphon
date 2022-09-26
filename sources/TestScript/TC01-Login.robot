*** Settings ***
Library   SeleniumLibrary
Library   ExcelLibrary
Library   Collections

Resource  ../Resources/TC01-Login.robot


*** Test Cases ***
TC01_Login 
    Begin Webpage
    Open Excel Document  TestData//TC01_Login.xlsx    doc_id=TestData
    ${eclin}   Get Sheet   TestData
    FOR       ${i}    IN RANGE   2     ${eclin.max_row+1}
              ${user}        Set Variable if    '${eclin.cell(${i},2).value}'=='None'    ${Empty}     ${eclin.cell(${i},2).value}
              ${pass}    Set Variable if    '${eclin.cell(${i},3).value}'=='None'    ${Empty}     ${eclin.cell(${i},3).value}

              Login Page      ${user}      ${pass}
                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${eclin.max_row}    Check Error page      ${eclin.cell(${i},4).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${eclin.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${eclin.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${eclin.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    6       value=${Status}        sheet_name=TestData
    END
    Save Excel Document       Result/WriteExcel/TC01_Login_result.xlsx
    Close All Excel Documents
    Close All Browsers

*** Keywords ***
Begin Webpage
        Open Browser            ${Login URL}     ${BROWSER}
        Maximize Browser Window
        Set Selenium Speed      0.3s

Login Page
    [Arguments]     ${username}         ${password}
    Input Text      ${user_username}    ${username}
    Input Text      ${user_password}    ${password}
    Click Element   ${btn_login}

Check Error page
    [Arguments]   ${ActualResult}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${ActualResult}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]

Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${header}
    ${message}  Set Variable if    '${Status}'=='True'      "Login เข้าสู่ระบบสำเร็จ!"            "Login เข้าสู่ระบบไม่สำเร็จ!"
    [Return]   ${Status}  ${message}

