*** Settings ***
Library    SeleniumLibrary
Test Setup       Login As Admin
Test Teardown    Close All Browsers

*** Variables ***
${URL}                  http://localhost/warehouse-inventory-system-master/
${SALES_REPORT_URL}     http://localhost/warehouse-inventory-system-master/sales_report.php
${MONTHLY_SALES_URL}    http://localhost/warehouse-inventory-system-master/monthly_sales.php
${DAILY_SALES_URL}      http://localhost/warehouse-inventory-system-master/daily_sales.php
${BROWSER}              chrome
${USERNAME}             admin
${PASSWORD}             admin
${START_DATE}           2026-08-01
${END_DATE}             2026-10-31

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
Sales By Dates Page Loads Successfully
    Go To    ${SALES_REPORT_URL}
    Wait Until Page Contains Element    name=start-date    10s
    Page Should Contain Element    name=start-date
    Page Should Contain Element    name=end-date
    Page Should Contain Element    xpath=//button[contains(.,'Generate Report')]

Generate Date Range Report Successfully
    Go To    ${SALES_REPORT_URL}
    Wait Until Page Contains Element    name=start-date    10s
    Input Text    name=start-date    ${START_DATE}
    Press Keys    name=start-date    TAB
    Input Text    name=end-date    ${END_DATE}
    Press Keys    name=end-date    ESC
    Click Button    xpath=//button[contains(.,'Generate Report')]
    Sleep    1s
    Page Should Contain Element    xpath=//table
    Log To Console    Date range report generated successfully

Monthly Sales Page Loads Successfully
    Go To    ${MONTHLY_SALES_URL}
    Wait Until Location Contains    monthly_sales.php    10s
    Page Should Contain    Product name
    Page Should Contain    Quantity sold
    Page Should Contain    Total
    Page Should Contain    Date
    Page Should Contain Element    xpath=//table

Monthly Sales Table Contains Data
    Go To    ${MONTHLY_SALES_URL}
    Wait Until Page Contains Element    xpath=//table    10s
    ${rows}=    Get Element Count    xpath=//table//tbody/tr
    Should Be True    ${rows} >= 1
    Log To Console    Monthly report contains ${rows} data row(s)

Daily Sales Page Loads Successfully
    Go To    ${DAILY_SALES_URL}
    Wait Until Location Contains    daily_sales.php    10s
    Page Should Contain    Product name
    Page Should Contain    Quantity sold
    Page Should Contain    Total
    Page Should Contain    Date
    Page Should Contain Element    xpath=//table

Daily Sales Table Is Displayed
    Go To    ${DAILY_SALES_URL}
    Wait Until Page Contains Element    xpath=//table    10s
    Page Should Contain Element    xpath=//table
    Log To Console    Daily sales report table displayed successfully
