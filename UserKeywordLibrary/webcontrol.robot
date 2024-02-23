*** Settings ***
Library    SeleniumLibrary    run_on_failure=nothing
Library    OperatingSystem    
Library    String
Library    DateTime
Library     Collections

*** Variables ***          
${BROWSER}                  Chrome
${SELENIUM_TIMEOUT}         60s
${SELENIUM_SPEED}           0.3s
${SELENIUM_SHORT_IMPLICITWAIT}    3s
${SELENIUM_LONG_IMPLICITWAIT}     30s
${seperator}                _

${RetryKeywordsTimeout}    60s
${RetryKeywordsUnittime}    3s
*** Keywords ***
Take Screenshot When Test Failed
    ${date} =      Get Current Date    result_format=%Y${seperator}%m${seperator}%d
    ${current_testcase} =     Replace "${SPACE}" To "_" In String "${TEST NAME}"
    ${current_testcase} =     Replace ">" To "_" In String "${TEST NAME}"
    ${screenshot_name} =     Set Variable    ${current_testcase}${date}
    Run Keyword If Test Failed    Capture Page Screenshot    ${screenshot_name}.png

#OPEN&CLOSE    
Open Browser With "${URL}"
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}   
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --no-sandbox
#    Open Browser    ${URL}    ${BROWSER}
    Wait Until Keyword Succeeds     60s     10s      Create Webdriver And Open URL  ${chrome_options}       ${url}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}
    Set Window Size    1920    1080
    ${width}    ${height}   Get Window Size   
    Log To Console    ${width} * ${height}
    Set Selenium Speed    ${SELENIUM_SPEED}
    
Create Webdriver And Open URL
    [Arguments]     ${chrome_options}       ${url}
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}
    
Open New Tab With "${url}"
    Execute Javascript    window.open()
    ${handle}=    Switch Window    NEW
    Go To    ${url}
    
Open New Tab With URL
    [Arguments]    ${url}
    Execute Javascript    window.open()
    ${handle}=    Switch Window    NEW
    Go To    ${url}
    RETURN   ${handle}
    
Get Window Height
    ${height}=    Execute Javascript    return screen.height
    RETURN    ${height}
    
Get Window Width
    ${width}=    Execute Javascript    return screen.width
    RETURN    ${width}

Close The Current Tab
    Execute Javascript    window.close()
    Select The Main Window
    
Close All Browser And Kill Related Process
    Run Keyword And Ignore Error    Close All Browsers    
    Sleep    1
    Run Keyword And Ignore Error    Kill Related Process For Browser    
    
Kill Related Process For Browser
    ${webDriver}    Set Variable If    '${BROWSER}'=='firefox'    geckodriver.exe
                                    ...  '${BROWSER}'=='chrome'    chromedriver.exe
    ${browserProc}    Set Variable If    '${BROWSER}'=='firefox'    firefox.exe
                                    ...  '${BROWSER}'=='chrome'    chrome.exe
    Kill Process "${webDriver}"
    Run Keyword And Ignore Error     Run CMD "wmic process where name='${webDriver}' delete" (Async)   
    Kill Process "${browserProc}" 

#INPUT
Input Text "${text}"In Element "${xpath}"
    Scroll To Element   ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Input Text        ${xpath}     ${text}
    
Select Custom Checkbox With Judgement
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}    
    ${checked_attribute}=    Get Attribute "checked" In Element "${xpath}"
    Run Keyword If    '${checked_attribute}'=='None'    Click Dynamic Element By Javascript    ${xpath}    @{ARGS}    
    
Clear Text In Element "${xpath}"
    Scroll To Element       ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Clear Element Text       ${xpath}    
    
Clear And Input "${text}" Text In "${xpath}" Element
    Clear Text In Element "${xpath}"
    Input Text "${text}"In Element "${xpath}"

Clear And Input Text In Dynamic Element
    [Arguments]        ${text}     ${xpath}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element    ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Clear Element Text       ${xpath}
    Input Text        ${xpath}     ${text}

Clear And Press Text In Dynamic Element
    [Arguments]        ${text}     ${xpath}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element    ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Clear Element Text       ${xpath}
    Press Keys       ${xpath}     ${text}


#GET
Get Text In Element "${xpath}"
    Wait Until Element Is Visible      ${xpath} 
    ${ret}=    Get Text    ${xpath}
    RETURN    ${ret}

Get Text From Dynamic Locator
    [Arguments]       ${xpath}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Wait Until Element Is Visible      ${xpath}
    ${ret}=    Get Text    ${xpath}
    RETURN    ${ret}
    
Get Value In Element "${xpath}"
    Wait Until Element Is Visible      ${xpath} 
    ${ret}=    Get Value    ${xpath}
    RETURN    ${ret}
    
Get Attribute "${attribute}" In Element "${xpath}"
    # Wait Until Element Is Visible      ${xpath} 
    ${ret}=    Get Element Attribute    ${xpath}    ${attribute}
    RETURN    ${ret}

Get Value Attribute In Dynamic Element
    [Arguments]        ${attribute}     ${xpath}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    # Wait Until Element Is Visible      ${xpath}
    ${ret}=    Get Element Attribute    ${xpath}    ${attribute}
    RETURN    ${ret}
    
#Scroll
Scroll Up To The Top
    Execute Javascript      window.scrollTo(0, -document.body.scrollHeight)

Scroll To The Bottom
    Execute Javascript      window.scrollTo(0, document.body.scrollHeight)

Scroll To Middle Of Page
    Execute Javascript      window.scrollTo(0, document.body.scrollHeight/3)

Scroll To Element
    [Arguments]      ${xpath}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}    
    ${webElement}       Get WebElement    ${xpath}
    Execute Javascript      arguments[0].scrollIntoView(true);      ARGUMENTS        ${webelement}
    Sleep   0.25
    
#CLICK
Click Element "${xpath}"
    Wait Until Element Is Visible      ${xpath}
    Scroll To Element       ${xpath}
    Click Element       ${xpath}
    
Click Element By Javascript
    [Arguments]      ${xpath}
    ${webElement}       Get WebElement    ${xpath}
    Execute Javascript      arguments[0].click();      ARGUMENTS        ${webelement}
    Sleep   0.25

Click Element "${xpath}" by Mouse Action
    Scroll To Element    ${xpath}
    Mouse Over    ${xpath}
    Mouse Down    ${xpath}

Double Click Element "${xpath}"
    Wait Until Element Is Visible      ${xpath}
    Double Click Element       ${xpath}    

Click Dynamic Element
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element   ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Click Element       ${xpath}
    
Click Dynamic Element By Mouse Action
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element   ${xpath}
    Wait Until Element Is Visible      ${xpath}
    Mouse Over    ${xpath}
    Sleep    2s  
    Mouse Down    ${xpath}
    
Click Dynamic Element By Javascript
    [Arguments]      ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    ${webElement}       Get WebElement    ${xpath}
    Execute Javascript      arguments[0].click();    ARGUMENTS        ${webElement}
    Sleep   0.25

Click Coodinates From A Dynamic Element
     [Arguments]        ${X}    ${Y}     ${xpath}     @{ARGS}
      ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
      Wait Until Element Is Visible      ${xpath}
      Click Element At Coordinates     ${xpath}      ${X}    ${Y}

#FORMAT    
Generate Dynamic Locator 
    [Arguments]    ${xpath}    @{ARGS} 
    ${xpath}=     Format String    ${xpath}    @{ARGS}
    RETURN    ${xpath}

#WAIT
Wait Until Page Source Contain "${text}"
    Wait Until Keyword Succeeds    30s    1s    Page Source Should Contain   ${text}
    
Wait "${time}" Until Page Source Contain "${text}"
    Wait Until Keyword Succeeds    ${time}    0.25s    Page Source Should Contain   ${text}
    
Wait Until Page Source Not Contain "${text}"
    Wait Until Keyword Succeeds    10s    2s    Page Source Should Not Contain   ${text}
    
Wait "${time}" Until Element "${xpath}" Contains Text "${text}"
    Wait Until Element Is Visible      ${xpath}  
    Wait Until Element Contains    ${xpath}    ${text}    timeout=${time}s
    
Wait Until Page Contains Text "${text}"
    Wait Until Page Contains    ${text}    ${SELENIUM_TIMEOUT}    
    
Wait Until Page Does Not Contains Text "${text}"
    Wait Until Page Does Not Contain    ${text}   
    
Wait Until Page Contains Element "${xpath}" 
    Wait Until Page Contains Element    ${xpath}     ${SELENIUM_TIMEOUT}
    
Wait Until Page Does Not Contains Elemnt "${xpath}"
    Wait Until Page Does Not Contain Element    ${xpath}
    
Wait "${timeout}" Until Element "${xpath}" Is Not Visible
    Set Selenium Implicit Wait    ${timeout}
    Wait Until Element Is Not Visible    ${xpath}    ${timeout}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}

Wait Until Element "${xpath}" Is Not Visible
    Set Selenium Implicit Wait    ${SELENIUM_SHORT_IMPLICITWAIT}
    Wait Until Element Is Not Visible    ${xpath}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}
    
Wait Until Dynamic Element Is Not Visible With Timeout
    [Arguments]     ${timeout}     ${xpath}        @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}    @{ARGS}
    Set Selenium Implicit Wait    ${timeout}
    Wait Until Element Is Not Visible    ${xpath}    ${timeout}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}
    
Wait Until Dynamic Element Is Not Visible
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Set Selenium Implicit Wait    ${SELENIUM_SHORT_IMPLICITWAIT}
    Wait Until Element Is Not Visible      ${xpath}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}
    
Wait "${time}" Until Element "${xpath}" Is Visible
    Wait Until Element Is Visible    ${xpath}    ${time}
    
Wait Until Dynamic Element Is Visible
    [Arguments]    ${xpath}        @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Wait Until Page Contains Element "${xpath}"
    Scroll To Element    ${xpath}
    Wait Until Element Is Visible      ${xpath}    ${SELENIUM_TIMEOUT}
    
Wait Until Dynamic Element Is Visible With Timeout
    [Arguments]    ${time}    ${xpath}        @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Wait Until Element Is Visible      ${xpath}    ${time}
    
Wait Until Element "${xpath}" Is Visible
    Wait Until Element Is Visible    ${xpath} 

Wait Until Dynamic Page Contain
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
   Wait Until Page Contains Element     ${xpath}
    
Wait Until Alert(Confirm) Pop Up 
    FOR  ${index}    IN RANGE    1    10
        ${flag}    Run Keyword And Return Status    Alert Should Be Present        
        Run Keyword If    ${flag}==${True}     Exit For Loop
        Sleep    1s
    Sleep    3s
    END

Wait Until Dynamic Element Is Enabled
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Wait Until Element Is Enabled    ${xpath}
    
#FRAME/ IFRAME
Wait And Select Frame "${iframe}"
    Wait Until Page Contains Element    ${iframe}  
    Select Frame    ${iframe}
    
Select Windown By Index "${n}"
    @{name}=    Get Window Names
    Switch Window    name=@{name}[${n}]
    
Select Windown By Title "${title}"
    Switch Window     title=${title}

Select Windown By URL "${url}"
    Switch Window    url=${url}

Select The New Window
    Switch Window     NEW
    Sleep    1s
    
Select The Main Window
    Switch Window    MAIN
    Sleep    1s    
    
Get Alert
    Wait Until Alert(Confirm) Pop Up
    ${ret}    Run Keyword And Ignore Error    Handle Alert    DISMISS
    ${ret}    Set Variable If    '${ret[0]}'=='${True}'    ${ret[1]}
                            ...    '${ret[0]}'=='${False}'  ${EMPTY}
    RETURN    ${ret}
    
Alert Message Should Contain Text "${text}"
    Wait Until Alert(Confirm) Pop Up
    @{message}=     Run Keyword And Ignore Error    Handle Alert        
    ${passed}=    Run Keyword And Return Status    Should Contain    @{message}[1]    ${text}        
    Run Keyword If      '@{message}[0]'=='PASS' 
    ...    Run Keyword Unless    ${passed}    fail  @{message}[1]      

Accept The Confirm
    Wait Until Alert(Confirm) Pop Up
    Handle Alert    

Cancel The Confirm
    Wait Until Alert(Confirm) Pop Up
    Handle Alert    DISMISS
    
Select Frame List "${frame list}"
    FOR    ${frame}     IN    @{frame list}
        Wait And Select Frame "${frame}"
    END


Click "${xpath}" Element In Frame List "${frame list}"
    Select Frame List "${frame list}"
    Click Element "${xpath}"
    
Get Window Count
    ${windows}=    Get Window Handles
    ${windowCount}=    Get Length    ${windows}
    RETURN    ${windowCount}
    
#SELECT COMBO BOX
Select "${xpath}" ComboBox By Label "${label}"
    Wait Until Element Is Visible    ${xpath}   
    Select From List By Label     ${xpath}   ${label}     
    
Select "${xpath}" ComboBox By Value "${value}"
    Wait Until Element Is Visible    ${xpath}   
    Select From List By Value     ${xpath}   ${value}

Select Dynamic ComboBox By Value 
    [Arguments]  ${value}     ${xpath}   @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}  
    Wait Until Element Is Visible    ${xpath}   
    Select From List By Value     ${xpath}   ${value}    
     
Select "${xpath}" ComboBox By Index "${index}"
    Wait Until Element Is Visible    ${xpath}   
    Select From List By Value     ${xpath}   ${index}    
     
#varidation
Element "${xpath}" Should Contains Text "${text}"
    Wait Until Element Is Visible      ${xpath}   
    Element Should Contain    ${xpath}    ${text}   
    
# Element "${xpath}" Not Should Contains Text "${text}"
#     Wait Until Page Contains Element    ${xpath}    
#     Element Should Contain    ${xpath}    ${text}

Element "${xpath}" Attribute Value "${Attribute}" Should Contains "${value}"
    Wait Until Element Is Visible      ${xpath} 
    ${actual_value}=    Get Attribute "${attribute}" In Element "${xpath}"
    Should Contain    ${actual_value}    ${value}

Element "${xpath}" Attribute Value "${Attribute}" Should Not Contains "${value}"
    Wait Until Element Is Visible      ${xpath} 
    ${actual_value}=    Get Attribute "${attribute}" In Element "${xpath}"
    Should Not Contain    ${actual_value}    ${value}

Element Text "${xpath}" Should Be Equal To "${text}"
    Wait Until Element Is Visible      ${xpath} 
    ${actual_value}=    Get Text In Element "${xpath}"
    Should Be Equal      ${actual_value}    ${text}

Dynamic Element Text Should Be Equal
    [Arguments]    ${xpath}    ${text}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element    ${xpath}
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Text In Element "${xpath}"
    Should Be Equal      ${actual_value}    ${text}
    
Dynamic Element Text Should Contains
    [Arguments]    ${xpath}    ${text}     @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Scroll To Element    ${xpath}
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Text In Element "${xpath}"
    Should Contain      ${actual_value}    ${text}

Element Text "${xpath}" Should Not Equal To "${text}"
    Wait Until Element Is Visible      ${xpath} 
    ${actual_value}=    Get Text In Element "${xpath}"
    Should Not Be Equal       ${actual_value}     ${text}

Element Value In "${xpath}" Should Equal To "${value}"
    Wait Until Element Is Visible      ${xpath} 
    ${actual_value}=    Get Value In Element "${xpath}"
    Should Be Equal      ${actual_value}     ${value}

Element Value In "${xpath}" Should Not Equal To "${value}"
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Value In Element "${xpath}"
    Should Not Be Equal      ${actual_value}     ${value}
    
Element "${xpath}" Attribute Value "${Attribute}" Should Be Equal "${value}"
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Attribute "${attribute}" In Element "${xpath}"
    Should Be Equal       ${actual_value}         ${value}    

Dynamic Element Attribute Value Should Be Equal
    [Arguments]    ${xpath}    ${attribute}    ${value}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Attribute "${attribute}" In Element "${xpath}"
    Should Be Equal       ${actual_value}         ${value}  
    
Dynamic Element Should Be Visible
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath} =    Generate Dynamic Locator    ${xpath}   @{ARGS}
    Element Should Be Visible    ${xpath}    
    
Element "${xpath}" Attribute Value "${Attribute}" Should Not Be Equal "${value}"
    Wait Until Element Is Visible      ${xpath}
    ${actual_value}=    Get Attribute "${attribute}" In Element "${xpath}"
    Should Not Be Equal       ${actual_value}         ${value}  
  
#process    
Kill Process "${processName}"
    Log To Console    Kill Process :     ${processName}
    OperatingSystem.Run    cmd /c taskkill /F /im ${processName}
    
#String
Replace "${value1}" To "${value2}" In String "${value3}"
    ${ret}=    Replace String    ${value3}    ${value1}    ${value2}   
    RETURN    ${ret}
    
Wait Until Page Ready
    Wait Until Keyword Succeeds    ${RetryKeywordsTimeout}    ${RetryKeywordsUnittime}    Is Page Ready    
    Sleep    1s

Is Page Ready
    ${is_ready}    Execute Javascript    return document.readyState=='complete' && (window.jQuery != null) && (jQuery.active==0)
    Should Be Equal    ${is_ready}    ${True}  
    
Verify "${item_1}" Equal "${item_2}" And Equal "${item_3}"
    Should Be Equal    ${item_1}    ${item_2}
    Should Be Equal    ${item_1}    ${item_3}    
    Should Be Equal    ${item_1}    ${item_3}    
    
"${price_1}" Price Contains "${price_2}" Price
    ${price_1}=    Remove String    ${price_1}    ,    THB    -    ${SPACE}
    ${price_2}=    Remove String    ${price_2}    ,    THB    -    ${SPACE}
    ${price_1}=    Convert To Number    ${price_1}    
    ${price_2}=    Convert To Number    ${price_2}    
    Should Be Equal    ${price_1}    ${price_2}   

Element Price Text Should Be
    [Arguments]    ${xpath}    ${expected_price}    @{ARGS}
    ${actual_price}=    Get Text From Dynamic Locator    ${xpath}    @{ARGS}    
    "${actual_price}" Price Contains "${expected_price}" Price
    
Dynamic Textbox Value Should Be   
    [Arguments]    ${xpath}    ${expected_value}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}
    Scroll To Element    ${xpath}
    ${actual_value}=    Get Attribute "value" In Element "${xpath}"
    Should Be Equal    ${actual_value}    ${expected_value}    
    
Dynamic Textbox Value Contains  
    [Arguments]    ${xpath}    ${expected_value}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}
    Scroll To Element    ${xpath}
    ${actual_value}=    Get Attribute "value" In Element "${xpath}"
    Should Contain    ${actual_value}    ${expected_value}   
    
Dynamic Element Content Attribute Value Should Be   
    [Arguments]    ${xpath}    ${expected_value}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}
    ${actual_value}=    Get Attribute "content" In Element "${xpath}"
    Should Be Equal    ${actual_value}    ${expected_value}    
    
Dynamic Element Attribute Value Should Contain  
    [Arguments]    ${expected_value}    ${attribute_name}    ${xpath}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}
    ${actual_value}=    Get Attribute "${attribute_name}" In Element "${xpath}"
    Should Contain    ${actual_value}    ${expected_value}    
    
Get Content Attribute Value From Dynamic Locator   
    [Arguments]    ${xpath}    @{ARGS}
    ${content_attribute_value}=    Get Value Attribute In Dynamic Element    content    ${xpath}    @{ARGS}
    RETURN    ${content_attribute_value}
    

Get Attribute From Dynamic Locator   
    [Arguments]    ${attribute_name}    ${xpath}    @{ARGS}
    ${attribute_value}=    Get Value Attribute In Dynamic Element    ${attribute_name}    ${xpath}    @{ARGS}
    RETURN    ${attribute_value}

Get Dynamic Element Count 
    [Arguments]    ${xpath}    @{ARGS}
    Wait Until Page Ready
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}    
    Set Selenium Implicit Wait    ${SELENIUM_SHORT_IMPLICITWAIT}
    ${count}    Get Element Count    ${xpath}
    Set Selenium Implicit Wait    ${SELENIUM_LONG_IMPLICITWAIT}
    ${count}=    Convert To Integer    ${count}    
    RETURN    ${count}
    
Click To Element If Element Visible
    [Arguments]    ${xpath}    @{ARGS}
    ${xpath}=    Generate Dynamic Locator    ${xpath}    @{ARGS}
    ${is_visible}    Run Keyword And Return Status    Element Should Be Visible    ${xpath}    3s    
    Run Keyword If    '${is_visible}'=='True'    Click Element "${xpath}"  
    
Page Source Contain 
    [Arguments]    ${text}
    Wait Until Page Ready
    ${source}=    Get Source
    ${status}=    Run Keyword And Return Status    Should Contain    ${source}    ${text}    
    RETURN    ${status}
    
Page Source Should Contain
    [Arguments]    ${text}
    Wait Until Page Ready
    ${source}=    Get Source
    Should Contain    ${source}    ${text}  
    
Page Source Should Not Contain
    [Arguments]    ${text}
    Wait Until Page Ready
    ${source}=    Get Source
    Should Not Contain    ${source}    ${text}  
  
Page Source Context "${text1}" Or "${text2}"
    ${status1}    Page Source Contain    ${text1}
    ${status2}    Page Source Contain    ${text2}
    Run Keyword If    "${status1}"=="True"    Return From Keyword
    Run Keyword If    "${status2}"=="True"    Return From Keyword
    Fail    Page source not contains "${text1}" or "${text2}"
    
    
