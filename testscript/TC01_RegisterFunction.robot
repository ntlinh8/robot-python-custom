*** Settings ***
Library     SeleniumLibrary
Library     BuiltIn
Library     ../libraries/SortFunction.py
Resource    ../libraries/webcontrol.robot
Test Teardown   Close All Browser And Kill Related Process
*** Variables ***
${URL}   https://demo.nopcommerce.com/notebooks
${Notebook_dropdown_SortBy}    //select[@id='products-orderby']

*** Test Cases ***
TC01 - Register with empty data
    Log To Console    TC01 - Register with empty data
    Open Browser With "${URL}"
    Wait Until Page Ready
    Select "${Notebook_dropdown_SortBy}" ComboBox By Label "Name: A to Z"
    Wait Until Page Ready
    Verify Sort Function Properly Work    Name: A to Z

    Select "${Notebook_dropdown_SortBy}" ComboBox By Label "Name: Z to A"
    Wait Until Page Ready
    Verify Sort Function Properly Work    Name: Z to A

    Select "${Notebook_dropdown_SortBy}" ComboBox By Label "Price: Low to High"
    Wait Until Page Ready
    Verify Sort Function Properly Work    Price: Low to High

    Select "${Notebook_dropdown_SortBy}" ComboBox By Label "Price: High to Low"
    Wait Until Page Ready
    Verify Sort Function Properly Work    Price: High to Low



