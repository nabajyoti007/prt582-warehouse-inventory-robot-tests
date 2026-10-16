*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}         http://localhost/warehouse-inventory-system-master/
${BROWSER}     chrome
${USERNAME}    admin
${PASSWORD}    admin
${ERROR_MSG}   Sorry Username/Password incorrect.

*** Test Cases ***

Login With Valid Credentials
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text    xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button    xpath=//button[contains(.,'Login')]
    Wait Until Location Contains    home.php    10s
    Close Browser

Valid Username Invalid Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text    xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    wrongpass
    Click Button    xpath=//button[contains(.,'Login')]
    Wait Until Page Contains    ${ERROR_MSG}    10s
    Close Browser

Invalid Username Valid Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text    xpath=(//input)[1]    wronguser
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button    xpath=//button[contains(.,'Login')]
    Wait Until Page Contains    ${ERROR_MSG}    10s
    Close Browser

Invalid Username Invalid Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text    xpath=(//input)[1]    wronguser
    Input Password    xpath=(//input)[2]    wrongpass
    Click Button    xpath=//button[contains(.,'Login')]
    Wait Until Page Contains    ${ERROR_MSG}    10s
    Close Browser

Empty Username Valid Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button    xpath=//button[contains(.,'Login')]
    Page Should Contain    Username
    Page Should Contain    Password
    Close Browser

Valid Username Empty Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text    xpath=(//input)[1]    ${USERNAME}
    Click Button    xpath=//button[contains(.,'Login')]
    Page Should Contain    Username
    Page Should Contain    Password
    Close Browser

Empty Username Empty Password
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Click Button    xpath=//button[contains(.,'Login')]
    Page Should Contain    Username
    Page Should Contain    Password
    Close Browser
