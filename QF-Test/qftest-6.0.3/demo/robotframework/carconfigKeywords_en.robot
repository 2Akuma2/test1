*** Settings ***
Resource    resource.txt

*** Keywords ***

Open Dialog Edit Vehicles
    Select Menu Item  ${menuOptions}    ${miVehicles}

Close Dialog
    [Arguments]      ${button}
    Mouse Click      ${button}


Check Of Price In The Table
    ${rows}   Get Row Count    ${tableFahrzeuge}
    FOR    ${row}    IN RANGE   ${rows}
        #select the tablecell using index
        Mouse Click    ${tableFahrzeuge}&0&${row}
        # alternate select the tablecell using names
        #mouse click     ${tableFahrzeuge}@Modell@${modellList}[${row}]
        ${modell} =   Get Text    ${tableFahrzeuge}&0&${row}
        ${preis} =   Get Text    ${tableFahrzeuge}&1&${row}
        Log To Console    ${modell}
        Log To Console    ${preis}
        Should Be Equal As Strings    ${modell}    ${modList}[${row}]
        Should Be Equal As Strings    ${preis}   $${prList_en}[${row}]
    END

