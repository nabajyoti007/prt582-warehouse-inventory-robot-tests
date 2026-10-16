*** Settings ***
Library    SeleniumLibrary
Test Setup       Open Browser And Login As Admin
Test Teardown    Close All Browsers

*** Variables ***
${URL}           http://localhost/warehouse-inventory-system-master/
${BROWSER}       chrome
${USERNAME}      admin
${PASSWORD}      admin

*** Keywords ***
Open Browser And Login As Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window
    Input Text        xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    ${PASSWORD}
    Click Button      xpath=//button[contains(.,'Login')]
    Wait Until Location Contains    home.php    10s

*** Test Cases ***
Navigation Menu Is Displayed
    Page Should Contain    Dashboard
    Page Should Contain    User Management
    Page Should Contain    Categories
    Page Should Contain    Products
    Page Should Contain    Meadias
    Page Should Contain    Sales
    Page Should Contain    Sales Report

Navigate To Dashboard
    Click Element    xpath=//a[contains(@href,'admin.php')]
    Wait Until Location Contains    admin.php    10s

Expand User Management Menu
    Click Element    xpath=//a[contains(.,'User Management')]
    Page Should Contain Element    xpath=//a[contains(@href,'group.php')]
    Page Should Contain Element    xpath=//a[contains(@href,'users.php')]

Navigate To Manage Groups
    Click Element    xpath=//a[contains(.,'User Management')]
    Click Element    xpath=//a[contains(@href,'group.php')]
    Wait Until Location Contains    group.php    10s

Navigate To Manage Users
    Click Element    xpath=//a[contains(.,'User Management')]
    Click Element    xpath=//a[contains(@href,'users.php')]
    Wait Until Location Contains    users.php    10s

Navigate To Categories
    Click Element    xpath=//a[contains(@href,'categorie.php')]
    Wait Until Location Contains    categorie.php    10s

Expand Products Menu
    Click Element    xpath=//a[contains(.,'Products')]
    Page Should Contain Element    xpath=//a[contains(@href,'product.php')]
    Page Should Contain Element    xpath=//a[contains(@href,'add_product.php')]

Navigate To Manage Products
    Click Element    xpath=//a[contains(.,'Products')]
    Click Element    xpath=//a[contains(@href,'product.php')]
    Wait Until Location Contains    product.php    10s

Navigate To Add Product
    Click Element    xpath=//a[contains(.,'Products')]
    Click Element    xpath=//a[contains(@href,'add_product.php')]
    Wait Until Location Contains    add_product.php    10s

Navigate To Media Page
    Click Element    xpath=//a[contains(@href,'media.php')]
    Wait Until Location Contains    media.php    10s

Expand Sales Menu
    Click Element    xpath=//a[normalize-space(.)='Sales']
    Page Should Contain Element    xpath=//a[contains(@href,'sales.php')]
    Page Should Contain Element    xpath=//a[contains(@href,'add_sale.php')]

Navigate To Manage Sales
    Click Element    xpath=//a[normalize-space(.)='Sales']
    Click Element    xpath=//a[contains(@href,'sales.php')]
    Wait Until Location Contains    sales.php    10s

Navigate To Add Sale
    Click Element    xpath=//a[normalize-space(.)='Sales']
    Click Element    xpath=//a[contains(@href,'add_sale.php')]
    Wait Until Location Contains    add_sale.php    10s

Expand Sales Report Menu
    Click Element    xpath=//a[contains(.,'Sales Report')]
    Page Should Contain Element    xpath=//a[contains(@href,'sales_report.php')]
    Page Should Contain Element    xpath=//a[contains(@href,'monthly_sales.php')]
    Page Should Contain Element    xpath=//a[contains(@href,'daily_sales.php')]

Navigate To Sales Report
    Click Element    xpath=//a[contains(.,'Sales Report')]
    Click Element    xpath=//a[contains(@href,'sales_report.php')]
    Wait Until Location Contains    sales_report.php    10s

Navigate To Monthly Sales Report
    Click Element    xpath=//a[contains(.,'Sales Report')]
    Click Element    xpath=//a[contains(@href,'monthly_sales.php')]
    Wait Until Location Contains    monthly_sales.php    10s

Navigate To Daily Sales Report
    Click Element    xpath=//a[contains(.,'Sales Report')]
    Click Element    xpath=//a[contains(@href,'daily_sales.php')]
    Wait Until Location Contains    daily_sales.php    10s
