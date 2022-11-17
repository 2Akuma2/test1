*** Settings ***
Resource      resource.txt
Suite Setup   Bezug Auf Abhaengigkeit     SUT started and reset

*** Test Cases ***
Preise Ohne Zubehör

    Oeffne Dialog Fahrzeuge Bearbeiten
    Modell und Preisprüfung in der Tabelle
    Schliesse Dialog    OK
