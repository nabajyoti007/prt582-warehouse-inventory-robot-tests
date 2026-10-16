*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    String
Test Setup       Login As Admin
Test Teardown    Close All Browsers

*** Variables ***
${URL}             http://localhost/warehouse-inventory-system-master/
${SALES_URL}       http://localhost/warehouse-inventory-system-master/sales.php
${ADD_SALE_URL}    http://localhost/warehouse-inventory-system-master/add_sale.php
${BROWSER}         chrome
${USERNAME}        admin
${PASSWORD}        admin
${PRODUCT_NAME}    Food

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
Add Sale Page Is Available
    Go To    ${ADD_SALE_URL}
    Wait Until Page Contains Element    name=title    10s
    Page Should Contain Element    name=title
    Page Should Contain Element    xpath=//button[contains(.,'Find It')]

Product Can Be Found For Sale
    Go To    ${ADD_SALE_URL}
    Input Text    name=title    ${PRODUCT_NAME}
    Click Button    xpath=//button[contains(.,'Find It')]
    Wait Until Page Contains Element    name=quantity    10s
    Page Should Contain    ${PRODUCT_NAME}
    Page Should Contain Element    name=price
    Page Should Contain Element    name=quantity
    Page Should Contain Element    name=total
    Page Should Contain Element    name=date

Complete Sale CRUD Workflow
    ${SALE_DATE}=    Get Current Date    result_format=%Y-%m-%d

    Go To    ${ADD_SALE_URL}
    Input Text    name=title    ${PRODUCT_NAME}
    Click Button    xpath=//button[contains(.,'Find It')]
    Wait Until Page Contains Element    name=quantity    10s

    Clear Element Text    name=quantity
    Input Text    name=quantity    1
    Clear Element Text    name=date
    Input Text    name=date    ${SALE_DATE}
    Click Button    xpath=//button[contains(.,'Add sale')]

    Go To    ${SALES_URL}
    Wait Until Page Contains    ${PRODUCT_NAME}    10s
    ${row}=    Set Variable    xpath=(//tr[.//td[contains(.,'${PRODUCT_NAME}')]])[1]
    Page Should Contain Element    ${row}

    ${EDIT_URL}=    Get Element Attribute    ${row}//a[contains(@href,'edit_sale.php')]    href
    ${DELETE_URL}=    Replace String    ${EDIT_URL}    edit_sale.php    delete_sale.php

    Go To    ${EDIT_URL}
    Wait Until Page Contains Element    name=quantity    10s
    Clear Element Text    name=quantity
    Input Text    name=quantity    2
    Clear Element Text    name=total
    Input Text    name=total    240.00
    Click Button    xpath=//button[contains(.,'Update sale')]

    Go To    ${SALES_URL}
    ${updated_row}=    Set Variable    xpath=//tr[.//td[contains(.,'${PRODUCT_NAME}')] and .//td[normalize-space(.)='2'] and .//td[contains(.,'240.00')]]
    Page Should Contain Element    ${updated_row}

    Go To    ${DELETE_URL}
    Go To    ${SALES_URL}
    Page Should Not Contain Element    xpath=//tr[.//td[contains(.,'${PRODUCT_NAME}')] and .//td[normalize-space(.)='2'] and .//td[contains(.,'240.00')]]
    Log To Console    Sale CRUD completed successfully
