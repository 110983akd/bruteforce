*** Settings ***
Library           OperatingSystem
Library           Collections
Library           String

*** Variables ***
${LOG_FILE}       login_attempts.log
${THRESHOLD}      10

*** Test Cases ***
Fail Immediately If Brute Force Detected
    ${content}=    Get File    ${LOG_FILE}
    ${lines}=      Split To Lines    ${content}
    ${failed_ips}=    Create Dictionary

    FOR    ${line}    IN    @{lines}
        ${is_failed}=    Run Keyword And Return Status    Should Contain    ${line}    SUCCESS: False
        IF    ${is_failed}
            ${ip_match}=    Get Regexp Matches    ${line}    IP: (\S+)
            ${ts_match}=    Get Regexp Matches    ${line}    ^(.*?) \|
            ${ip_len}=    Get Length    ${ip_match}
            ${ts_len}=    Get Length    ${ts_match}
            Run Keyword If    ${ip_len} > 0 and ${ts_len} > 0
            ...    Store Failed Attempt    ${ip_match}    ${ts_match}    ${failed_ips}
        END
    END

    FOR    ${ip}    IN    @{failed_ips.keys()}
        ${times}=    Get From Dictionary    ${failed_ips}    ${ip}
        ${count}=    Get Length    ${times}
        Log To Console    === DEBUG: Count for IP ${ip} is ${count}, threshold is ${THRESHOLD}
        ${is_exceeded}=    Evaluate    int(${count}) > int(${THRESHOLD})
        Run Keyword If    ${is_exceeded}
        ...    Log To Console    ALERT: IP ${ip} failed ${count} times. Last at ${times[-1]}
        ...    Should Be Equal As Strings    FAIL_NOW    PASS
    END

*** Keywords ***
Store Failed Attempt
    [Arguments]    ${ip_match}    ${ts_match}    ${failed_ips}
    ${ip}=    Get From List    ${ip_match}    0
    ${ts}=    Get From List    ${ts_match}    0
    Run Keyword If    '${ip}' in ${failed_ips}
    ...    Append To List    ${failed_ips['${ip}']}    ${ts}
    ...    ELSE
    ...    Set To Dictionary    ${failed_ips}    ${ip}=${ts}
