*** Settings ***
Library    SeleniumLibrary
Test Setup       Open Admin Login
Test Teardown    Close All Browsers

*** Variables ***
${URL}           http://localhost/warehouse-inventory-system-master/
${BROWSER}       chrome
${USERNAME}      admin
${PASSWORD}      admin

*** Keywords ***
Open Admin Login
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window

Login As Admin
    Input Text        xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button      xpath=//button[contains(.,'Login')]
    Wait Until Location Contains    home.php    10s

*** Test Cases ***
Admin Can Login And Reach Dashboard
    Login As Admin
    Location Should Contain    home.php

Admin Dashboard Page Loads Successfully
    Login As Admin
    Wait Until Page Contains    Dashboard    10s
    Page Should Contain    Dashboard
