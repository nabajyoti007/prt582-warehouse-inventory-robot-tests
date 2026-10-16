*** Settings ***
Library    SeleniumLibrary
Library    DateTime
Library    Collections

Test Setup       Login As Admin
Test Teardown    Close All Browsers


*** Variables ***
${URL}             http://localhost/warehouse-inventory-system-master/
${GROUP_URL}       http://localhost/warehouse-inventory-system-master/group.php
${ADD_GROUP_URL}   http://localhost/warehouse-inventory-system-master/add_group.php

${BROWSER}         chrome
${USERNAME}        admin
${PASSWORD}        admin


*** Keywords ***
Login As Admin
    Open Browser    ${URL}    ${BROWSER}
    Set Selenium Speed    0.25 seconds
    Maximize Browser Window

    Input Text        xpath=(//input)[1]    ${USERNAME}
    Input Password    xpath=(//input)[2]    ${PASSWORD}

    Click Button    xpath=//button[contains(.,'Login')]

    Wait Until Location Contains    home.php    10s


Get Next Available Group Level
    Go To    ${GROUP_URL}
    Wait Until Location Contains    group.php    10s

    ${level_cells}=    Get WebElements    xpath=//table//tbody/tr/td[3]

    ${levels}=    Create List

    FOR    ${cell}    IN    @{level_cells}
        ${text}=    Get Text    ${cell}

        IF    '${text}' != ''
            ${number}=    Convert To Integer    ${text}
            Append To List    ${levels}    ${number}
        END
    END

    ${count}=    Get Length    ${levels}

    IF    ${count} == 0
        ${NEXT_LEVEL}=    Set Variable    1
    ELSE
        ${MAX_LEVEL}=    Evaluate    max(${levels})
        ${NEXT_LEVEL}=    Evaluate    ${MAX_LEVEL} + 1
    END

    Log To Console    Next available group level: ${NEXT_LEVEL}

    RETURN    ${NEXT_LEVEL}


*** Test Cases ***

Group Form Is Available
    Go To    ${ADD_GROUP_URL}

    Wait Until Page Contains Element    name=group-name    10s

    Page Should Contain Element    name=group-name
    Page Should Contain Element    name=group-level
    Page Should Contain Element    name=status


Complete Group CRUD Workflow
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S

    ${GROUP_NAME}=       Set Variable    Robot Group ${timestamp}
    ${UPDATED_GROUP}=    Set Variable    Robot Group UPDATED ${timestamp}

    ${GROUP_LEVEL}=    Get Next Available Group Level

    # --------------------
    # CREATE GROUP
    # --------------------

    Go To    ${ADD_GROUP_URL}

    Wait Until Page Contains Element    name=group-name    10s

    Input Text    name=group-name     ${GROUP_NAME}
    Input Text    name=group-level    ${GROUP_LEVEL}

    Select From List By Value    name=status    1

    Click Button    xpath=//button[contains(.,'Update')]

    Sleep    1s

    Go To    ${GROUP_URL}

    Wait Until Page Contains    ${GROUP_NAME}    10s

    ${row}=    Set Variable
    ...    xpath=//tr[.//td[contains(.,'${GROUP_NAME}')]]

    Page Should Contain Element    ${row}

    Log To Console    Group created successfully: ${GROUP_NAME}


    # --------------------
    # GET DYNAMIC EDIT URL
    # --------------------

    ${EDIT_URL}=    Get Element Attribute
    ...    ${row}//a[contains(@href,'edit_group.php')]
    ...    href

    Log To Console    Dynamic group edit URL: ${EDIT_URL}


    # --------------------
    # EDIT GROUP
    # --------------------

    Go To    ${EDIT_URL}

    Wait Until Location Contains    edit_group.php    10s
    Wait Until Page Contains Element    name=group-name    10s

    Clear Element Text    name=group-name
    Input Text    name=group-name    ${UPDATED_GROUP}

    Clear Element Text    name=group-level
    Input Text    name=group-level    ${GROUP_LEVEL}

    Select From List By Value    name=status    1

    Click Button    xpath=//button[contains(.,'Update')]

    Sleep    1s

    Go To    ${GROUP_URL}

    Wait Until Page Contains    ${UPDATED_GROUP}    10s

    ${updated_row}=    Set Variable
    ...    xpath=//tr[.//td[contains(.,'${UPDATED_GROUP}')]]

    Page Should Contain Element    ${updated_row}

    Log To Console    Group updated successfully: ${UPDATED_GROUP}


    # --------------------
    # GET DYNAMIC DELETE URL
    # --------------------

    ${DELETE_URL}=    Get Element Attribute
    ...    ${updated_row}//a[contains(@href,'delete_group.php')]
    ...    href

    Log To Console    Dynamic group delete URL: ${DELETE_URL}


    # --------------------
    # DELETE GROUP
    # --------------------

    Go To    ${DELETE_URL}

    Sleep    1s

    Go To    ${GROUP_URL}

    Wait Until Location Contains    group.php    10s

    Page Should Not Contain    ${UPDATED_GROUP}

    Log To Console    Group deleted successfully
    Log To Console    Group CRUD completed successfully