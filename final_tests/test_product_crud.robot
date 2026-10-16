*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Test Setup       Login As Admin
Test Teardown    Close All Browsers

*** Variables ***
${URL}                 http://localhost/warehouse-inventory-system-master/
${PRODUCT_URL}         http://localhost/warehouse-inventory-system-master/product.php
${ADD_PRODUCT_URL}     http://localhost/warehouse-inventory-system-master/add_product.php
${BROWSER}             chrome
${USERNAME}            admin
${PASSWORD}            admin

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
Product Form Is Available
    Go To    ${ADD_PRODUCT_URL}
    Wait Until Page Contains Element    name=product-title    10s
    Page Should Contain Element    name=product-title
    Page Should Contain Element    name=product-categorie
    Page Should Contain Element    name=product-photo
    Page Should Contain Element    name=product-quantity
    Page Should Contain Element    name=buying-price
    Page Should Contain Element    name=saleing-price

Complete Product CRUD Workflow
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${PRODUCT_NAME}=    Set Variable    Robot Product ${timestamp}
    ${UPDATED_NAME}=    Set Variable    Robot Product UPDATED ${timestamp}

    Go To    ${ADD_PRODUCT_URL}
    Wait Until Page Contains Element    name=product-title    10s
    Input Text    name=product-title    ${PRODUCT_NAME}
    Select From List By Value    name=product-categorie    1
    Select From List By Value    name=product-photo    1
    Input Text    name=product-quantity    25
    Input Text    name=buying-price    10
    Input Text    name=saleing-price    20
    Click Button    xpath=//button[contains(.,'Add product')]

    Go To    ${PRODUCT_URL}
    Wait Until Page Contains    ${PRODUCT_NAME}    10s
    ${row}=    Set Variable    xpath=//tr[.//td[contains(.,'${PRODUCT_NAME}')]]
    Page Should Contain Element    ${row}

    ${EDIT_URL}=    Get Element Attribute    ${row}//a[contains(@href,'edit_product.php')]    href
    Go To    ${EDIT_URL}
    Wait Until Page Contains Element    name=product-title    10s
    Clear Element Text    name=product-title
    Input Text    name=product-title    ${UPDATED_NAME}
    Clear Element Text    name=product-quantity
    Input Text    name=product-quantity    50
    Clear Element Text    name=buying-price
    Input Text    name=buying-price    15
    Clear Element Text    name=saleing-price
    Input Text    name=saleing-price    30
    Click Button    xpath=//button[contains(.,'Update')]

    Go To    ${PRODUCT_URL}
    Wait Until Page Contains    ${UPDATED_NAME}    10s
    ${updated_row}=    Set Variable    xpath=//tr[.//td[contains(.,'${UPDATED_NAME}')]]
    Page Should Contain Element    ${updated_row}

    ${DELETE_URL}=    Get Element Attribute    ${updated_row}//a[contains(@href,'delete_product.php')]    href
    Go To    ${DELETE_URL}
    Go To    ${PRODUCT_URL}
    Page Should Not Contain    ${UPDATED_NAME}
    Log To Console    Product CRUD completed successfully
