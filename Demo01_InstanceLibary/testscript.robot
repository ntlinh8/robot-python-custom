*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     ../Demo01_InstanceLibary/SortFunction.py
Suite Setup     Run Keywords    Open Browser    ${URL}      AND     Wait Until Page Ready
Test Teardown   Close All Browsers
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


