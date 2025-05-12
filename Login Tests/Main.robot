*** Settings ***
Library    Process
Library    BuiltIn
Library    OperatingSystem
Library    String

*** Variables ***
${RESULT FILE}    datadriven_output.xml

*** Test Cases ***
Run DataDriven And Pass If One Test Passes
    ${command}=    Set Variable    robot --output ${RESULT FILE} DataDriven.robot
    ${result}=     Run Process    ${command}    shell=True    cwd=${CURDIR}    stdout=robot_out.txt    stderr=robot_err.txt

    ${stdout}=     Get File    robot_out.txt
    ${stderr}=     Get File    robot_err.txt
    Log    ⏱ STDOUT:\n${stdout}
    Log    ⚠️ STDERR:\n${stderr}

    File Should Exist    ${RESULT FILE}
    ${xml}=        Get File    ${RESULT FILE}
    ${before}=     Get Length    ${xml}
    ${replaced}=   Replace String    ${xml}    status="PASS"    ✅
    ${after}=      Get Length    ${replaced}
    ${match_len}=  Get Length    status="PASS"
    ${count}=      Evaluate    (${before} - ${after}) // ${match_len}

    Log    ✅ Number of passed tests: ${count}
    Run Keyword If    ${count} > 0    Log    ✅ At least one test passed
    Run Keyword If    ${count} == 0    Fail    ❌ No test passed
