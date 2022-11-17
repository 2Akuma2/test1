*** Settings ***
Resource      resource.txt
Suite Setup   Dependency Reference     SUT started and reset    language=${language}

*** Test Cases ***
Prices Without Accessories

    Open Dialog Edit Vehicles
    Check Of Price In The Table
    Close Dialog    OK


*** Variables ***
${language}             en