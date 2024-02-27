*** Settings ***
Library     BuiltIn
Library     BestBuyAPI.py
*** Variables ***
${id}   ${EMPTY}
&{product_information}             name=Samsung Electronic Firefrighter     type=machine       price=${350}    shipping=${20}   upc=AU   description=The best choise for every family    manufacturer=Teddy Bear    model=SS1   url=https://samsung.com/   image=firefrighter.png
&{updated_product_information}     name=Samsung Electronic Firefrighter1     type=machine1       price=${360}    shipping=${30}   upc=AU   description=The best choise for every family    manufacturer=Teddy Bear    model=SS1   url=https://samsung.com/   image=firefrighter.png
*** Test Cases ***
Product 01 - Get All Products Information
    Log To Console    Product 01 - Get All Products Information
    ${all_product_information}=     Get All Products
    Log To Console    ${all_product_information}[total]

Product 02 - Create A New Product
    Log To Console    Product 02 - Create A New Product
    ${new_id}=  Create New Product    ${product_information}
    Log To Console    ${new_id}
    Set Global Variable    ${id}    ${new_id}
    
Product 03 - Get The Product By ID
    Log To Console    Product 03 - Get The Product By ID
    ${actual_information}=     Get Product Information By Id    ${id}
    Should Be Equal    ${actual_information}[name]    ${product_information}[name]
    Should Be Equal    ${actual_information}[type]    ${product_information}[type]
    Should Be Equal    ${actual_information}[price]    ${product_information}[price]
    Should Be Equal    ${actual_information}[shipping]    ${product_information}[shipping]
    Should Be Equal    ${actual_information}[upc]    ${product_information}[upc]
    Should Be Equal    ${actual_information}[description]    ${product_information}[description]
    Should Be Equal    ${actual_information}[manufacturer]    ${product_information}[manufacturer]
    Should Be Equal    ${actual_information}[url]    ${product_information}[url]
    Should Be Equal    ${actual_information}[image]    ${product_information}[image]

Product 04 - Update The Product Information
    Log To Console    Product 04 - Update The Product Information
    Update Product Information    ${id}    ${updated_product_information}
    
    Log To Console    Get the product information and verify
    ${actual_information}=     Get Product Information By Id    ${id}
    Should Be Equal    ${actual_information}[name]            ${updated_product_information}[name]
    Should Be Equal    ${actual_information}[type]            ${updated_product_information}[type]
    Should Be Equal    ${actual_information}[price]           ${updated_product_information}[price]
    Should Be Equal    ${actual_information}[shipping]        ${updated_product_information}[shipping]
    Should Be Equal    ${actual_information}[upc]             ${updated_product_information}[upc]
    Should Be Equal    ${actual_information}[description]     ${updated_product_information}[description]
    Should Be Equal    ${actual_information}[manufacturer]    ${updated_product_information}[manufacturer]
    Should Be Equal    ${actual_information}[url]             ${updated_product_information}[url]
    Should Be Equal    ${actual_information}[image]           ${updated_product_information}[image]
    
Product 05 - Delete The Product
    Log To Console    Product 05 - Delete The Product
    ${status_code}=     Delete Product By Id    ${id}
    Should Be Equal    ${status_code}    ${200}

