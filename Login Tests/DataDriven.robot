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
    Input username    ${username}
    Input pwd         ${password}
    click login button
    ${title}=    Get Title
    Should Be Equal    ${title}    Dashboard    Login failed for user '${username}' with password '${password}'

