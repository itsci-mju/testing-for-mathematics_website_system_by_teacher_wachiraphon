*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          String
Library          Collections

Resource  ../Resources/TC11-ImportStudent.robot

*** Variables ***
${BROWSER}           Chrome
${URL}               http://localhost:8081/Test_01/login
${URL}               http://localhost:8081/Test_01/login#features
${TIME_WAIT}         5s

*** Test Cases ***
Test11_ImportStudent
    Begin Webpage
    Login Page  kawfang   1234
    Open Excel Document     TestData//TC11_ImportStudent.xlsx     doc_id=TestData
    ${ImportStudent}   Get Sheet   TestData
        FOR   ${i}    IN RANGE   2     ${ImportStudent.max_row+1}
        Go to  ${ImportStudent URL} 
        Click Element                   ${manages}
        Click Element                   ${Import}
              ${name_subject1}        Set Variable if    '${ImportStudent.cell(${i},2).value}'=='None'    ${Empty}     ${ImportStudent.cell(${i},2).value}
              ${fileExcel}            Set Variable if    '${ImportStudent.cell(${i},3).value}'=='None'    ${Empty}     ${ImportStudent.cell(${i},3).value}
              
        
              ImportStudent Page      ${name_subject1}      ${fileExcel}

                ${Status_1}   ${message_1}  Run Keyword If    ${i}!=${ImportStudent.max_row}    Check Error page     ${ImportStudent.cell(${i},4).value}
                ${Status_2}   ${message_2}  Run Keyword If    ${i}==${ImportStudent.max_row}    Check Home Page

                ${Status}       Set Variable if    ${i}==${ImportStudent.max_row}   ${Status_2}     ${Status_1}
                ${Status}       Set Variable if    '${Status}'=='True'      Pass            Fail
                ${message}      Set Variable if    ${i}==${ImportStudent.max_row}   ${message_2}     ${message_1}

                Write Excel Cell        ${i}    5       value=${message}        sheet_name=TestData
                Write Excel Cell        ${i}    6       value=${Status}         sheet_name=TestData
        END
    Save Excel Document       Result/WriteExcel/TC11_CImportStudent_result.xlsx
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


ImportStudent Page
    [Arguments]   ${name_subject1}    ${fileExcel}    
    Select From List By Label         ${name_subject}      ${name_subject1}  
    Run Keyword If     '${fileExcel}'!=' ${Empty}'     Choose File        id=fileExcel     ${fileExcel}         
    Click Element   //body/form[2]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/input[2]


Check Home Page
    ${Status}   Run Keyword And Return Status   Wait Until Element Is Visible    ${footer}
    ${message}  Set Variable if    '${Status}'=='True'      "เพิ่มข้อมูลสำเร็จ"     "เพิ่มข้อมูลไม่สำเร็จ!"
    [Return]   ${Status}  ${message}


Check Error page
    [Arguments]   ${message}
    ${get_message}   Run keyword and ignore error       Handle Alert
    ${Status}  Run Keyword And Return Status      Should Be Equal    ${message}     ${get_message}
    [Return]   ${Status}  ${get_message}[1]




