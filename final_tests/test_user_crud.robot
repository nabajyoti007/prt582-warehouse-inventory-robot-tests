*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Test Setup       Login As Admin
Test Teardown    Close All Browsers

*** Variables ***
${URL}            http://localhost/warehouse-inventory-system-master/
${USERS_URL}      http://localhost/warehouse-inventory-system-master/users.php
${ADD_USER_URL}   http://localhost/warehouse-inventory-system-master/add_user.php
${BROWSER}        chrome
${USERNAME}       admin
${PASSWORD}       admin

*** Keywords ***
Login As Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text        xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button      xpath=//button[contains(.,'Login')]
    Wait Until Location Contains    home.php    10s

*** Test Cases ***
Add User Form Is Available
    Go To    ${ADD_USER_URL}
    Wait Until Page Contains Element    name=full-name    10s
    Page Should Contain Element    name=full-name
    Page Should Contain Element    name=username
    Page Should Contain Element    name=password
    Page Should Contain Element    name=level

Complete User CRUD Workflow
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${FULL_NAME}=    Set Variable    Robot User ${timestamp}
    ${NEW_USERNAME}=    Set Variable    robot${timestamp}
    ${UPDATED_NAME}=    Set Variable    Robot User UPDATED ${timestamp}
    ${UPDATED_USERNAME}=    Set Variable    updated${timestamp}

    Go To    ${ADD_USER_URL}
    Input Text        name=full-name    ${FULL_NAME}
    Input Text        name=username     ${NEW_USERNAME}
    Input Password    name=password     Test@12345
    Select From List By Value    name=level    3
    Click Button    xpath=//button[contains(.,'Add User')]

    Go To    ${USERS_URL}
    Wait Until Page Contains    ${FULL_NAME}    10s
    ${row}=    Set Variable    xpath=//tr[.//td[contains(.,'${FULL_NAME}')]]
    Page Should Contain Element    ${row}

    ${EDIT_URL}=    Get Element Attribute    ${row}//a[contains(@href,'edit_user.php')]    href
    Go To    ${EDIT_URL}
    Wait Until Page Contains Element    name=name    10s
    Clear Element Text    name=name
    Input Text    name=name    ${UPDATED_NAME}
    Clear Element Text    name=username
    Input Text    name=username    ${UPDATED_USERNAME}
    Select From List By Value    name=level    2
    Select From List By Value    name=status    1
    Click Button    xpath=//button[normalize-space(.)='Update']

    Go To    ${USERS_URL}
    Wait Until Page Contains    ${UPDATED_NAME}    10s
    ${updated_row}=    Set Variable    xpath=//tr[.//td[contains(.,'${UPDATED_NAME}')]]
    Page Should Contain Element    ${updated_row}
    Page Should Contain    Special
    Page Should Contain    Active

    ${DELETE_URL}=    Get Element Attribute    ${updated_row}//a[contains(@href,'delete_user.php')]    href
    Go To    ${DELETE_URL}
    Go To    ${USERS_URL}
    Page Should Not Contain    ${UPDATED_NAME}
    Log To Console    User CRUD completed successfully
