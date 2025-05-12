*** Settings ***
Library     SeleniumLibrary 


*** Variables ***
${LOGIN URL}    http://127.0.0.1:5000
${BROWSER}      firefox
${LOGIN_SUCCESS}    False

*** Keywords ***
Open my Browser
    Open Browser    ${LOGIN URL}    browser=${BROWSER}
    Set Window Position    0    0
    Set Window Size    960    1000

Close Browsers
    Close All Browsers

Open Login Page
    Go To    ${LOGIN URL}

Input username
    [Arguments]    ${username}
    Input Text    id=Username    ${username}

Input pwd
    [Arguments]    ${password}
    Input Password    id=Password    ${password}

click login button
    Click Button    id=Login

welcome page should be visible
    Title Should Be    Dashboard

Error page should be visible
    Title Should Be    Login
