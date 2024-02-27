*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     SortFunction.py
Suite Setup     Run Keywords    Open Browser With "${URL}"      AND     Wait Until Page Ready
Suite Teardown   Close All Browsers
*** Variables ***
${URL}   https://demo.nopcommerce.com/notebooks
${Notebook_dropdown_SortBy}    //select[@id='products-orderby']

*** Test Cases ***
TC01 - Sort with name
    Log To Console    TC01 - Sort with name
    Select From List By Label     ${Notebook_dropdown_SortBy}   Name: A to Z
    Wait Until Page Ready
    Verify Sort Function Properly Work    Name: A to Z

    Select From List By Label     ${Notebook_dropdown_SortBy}   Name: Z to A
    Wait Until Page Ready
    Verify Sort Function Properly Work    Name: Z to A

TC02 - Sort with price
    Log To Console    TC02 - Sort with price
    Select From List By Label     ${Notebook_dropdown_SortBy}   Price: Low to High
    Wait Until Page Ready
    Verify Sort Function Properly Work    Price: Low to High

    Select From List By Label     ${Notebook_dropdown_SortBy}   Price: High to Low
    Wait Until Page Ready
    Verify Sort Function Properly Work    Price: High to Low

*** Keywords ***
Wait Until Page Ready
    Wait Until Keyword Succeeds    60s    3s    Is Page Ready
    Sleep    1s

Is Page Ready
    ${is_ready}    Execute Javascript    return document.readyState=='complete' && (window.jQuery != null) && (jQuery.active==0)
    Should Be Equal    ${is_ready}    ${True}

Open Browser With "${URL}"
    Set Selenium Timeout    30s
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    Call Method    ${chrome_options}    add_argument    --no-sandbox
#    Open Browser    ${URL}    ${BROWSER}
    Wait Until Keyword Succeeds     60s     10s      Create Webdriver And Open URL  ${chrome_options}       ${url}
    Set Selenium Implicit Wait    30s
    Set Window Size    1920    1080
    ${width}    ${height}   Get Window Size
    Log To Console    ${width} * ${height}
    Set Selenium Speed    0.3s

Create Webdriver And Open URL
    [Arguments]     ${chrome_options}       ${url}
    Create Webdriver    Chrome    chrome_options=${chrome_options}
    Go To    ${url}
