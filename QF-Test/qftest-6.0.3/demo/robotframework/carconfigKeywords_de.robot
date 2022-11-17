*** Settings ***
Resource    resource.txt

*** Keywords ***

Oeffne Dialog Fahrzeuge Bearbeiten
    Waehle Menue Item  ${menuOptions}    ${miVehicles}

Schliesse Dialog
    [Arguments]      ${button}
    Mausklick      ${button}


Modell und Preisprüfung in der Tabelle
    ${rows}   Anzahl Zeilen    ${tableFahrzeuge}
    FOR    ${row}    IN RANGE   ${rows}
        Mausklick    ${tableFahrzeuge}&0&${row}
        # alternativ Tabelle mit Text ansprechen
        #Mausklick     ${tableFahrzeuge}@Modell@${modellList}[${row}]
        ${modell} =   Text Auslesen    ${tableFahrzeuge}&0&${row}
        ${preis} =   Text Auslesen    ${tableFahrzeuge}&1&${row}
        Log To Console    ${modell}
        Log To Console    ${preis}
        Should Be Equal As Strings    ${modell}    ${modList}[${row}]
        Should Be Equal As Strings    ${preis}    ${prList}[${row}] €
    END

