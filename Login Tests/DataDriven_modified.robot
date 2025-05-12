*** Settings ***
Library             DataDriver    file=commonlogins.csv
Resource            login_resources.robot

Suite Setup         Open my Browser
Suite Teardown      Close Browsers
Test Setup          Open Login Page
Test Template       Valid Login Should Succeed


*** Test Cases ***
Login with user '${username}' and password '${password}'    Default    UserData


*** Keywords ***
Valid Login Should Succeed
    [Arguments]    ${username}    ${password}

    Run Keyword If    '${LOGIN_SUCCESS}' == 'True'
    ...    Fail    SKIPPED: Login already succeeded with previous credentials

    Go To            ${LOGIN URL}
    Input Text       id=Username    ${username}
    Input Password   id=Password    ${password}
    Click Button     id=Login
    ${title}=        Get Title

    IF    '${title}' == 'Dashboard'
        Log To Console     Login successful with username: ${username} and password: ${password}
        Element Should Be Visible    id=Logout
        Set Global Variable    ${LOGIN_SUCCESS}    True
        Should Be Equal    ${title}    Dashboard
    ELSE
        Should Be Equal    ${title}    Dashboard    Login failed for user '${username}' with password '${password}'
    END