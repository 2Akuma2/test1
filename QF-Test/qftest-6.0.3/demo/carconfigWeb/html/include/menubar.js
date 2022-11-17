/********************************************************************
 *
 * $Id: CarConfigurator, v 1.1 2012/03/20 16:01:28
 *
 * Copyright (C) 2012 Quality First Software
 * All rights reserved
 *
 * Author: QFS (qfs@qfs.de), Yann Spoeri
 *******************************************************************/
 
 /* 
  * Methods for the menubar
  */
 
 // {{{ menubar open and closing function
 
 function closeAllMenuBars() {
    mFileClose();
    mOptionsClose();
    mOrderClose();
    mHelpClose();
 }
 
 var dummyvarformyFileClick = false;
 function mFileClick() {
    if(dummyvarformyFileClick) {
        mFileClose();
    } else {
        mFileOpen();
    }
 }
 function mFileOpen() {
    dummyvarformyFileClick = true;
    document.getElementById('mFile').getElementsByTagName('ul')[0].style.display = "block";
    mOptionsClose();
    mOrderClose();
    mHelpClose();
 }
 function mFileClose() {
    dummyvarformyFileClick = false;
    document.getElementById('mFile').getElementsByTagName('ul')[0].style.display = "none";
 }
 function mFileMove() {
    if ( dummyvarformyFileClick || dummyvarformyOptionsClick || dummyvarformyOrderClick || dummyvarformyHelpClick ) {
      mFileOpen();
    }
 }
 
 function miResetClick() {
    document.getElementById('AddAccessoryPriceChkbox').checked = true;
    vehicleNames = Array(getLanguageStringbyIdStr("VehicleRolo"), getLanguageStringbyIdStr("VehicleGolf"), getLanguageStringbyIdStr("VehicleRassant"), getLanguageStringbyIdStr("VehicleRassantFamily"), getLanguageStringbyIdStr("VehicleI5"));
    vehicleID = Array("M1", "M2", "M3", "M4", "M5");
    vehicle_price = Array(12300, 15000, 17000, 18500, 29000);
    vehicle_specialmodel_name = Array(getLanguageStringbyIdStr("ModelNoModel"), getLanguageStringbyIdStr("ModelGomera"), getLanguageStringbyIdStr("ModelJazz"), getLanguageStringbyIdStr("ModelLuxus"));
    vehicle_specialmodel_desc = Array(getLanguageStringbyIdStr("ModelNoModelDesc"), getLanguageStringbyIdStr("ModelGomeraDesc"), getLanguageStringbyIdStr("ModelJazzDesc"), getLanguageStringbyIdStr("ModelLuxusDesc"));
    vehicle_specialmodel_extra = Array("", "xS3xxS2xxS5x", "xS6xxS7xxS3x", "xS6xxS5xxS4xxS2x");
    vehicle_specialmodel_price = Array(0, 1413, 1049, 2499.99);
    accessory_name = Array(getLanguageStringbyIdStr("AccessoTableWheel"), getLanguageStringbyIdStr("AccessoTableMirror"), getLanguageStringbyIdStr("AccessoTableDoors"), getLanguageStringbyIdStr("AccessoTableRims"), getLanguageStringbyIdStr("AccessoTableAntiSkidSys"), getLanguageStringbyIdStr("AccessoTablePowerWindows"), getLanguageStringbyIdStr("AccessoTableRadio"), getLanguageStringbyIdStr("AccessoTableMats"));
    accessory_price = Array(360, 210, 1200, 900, 990, 490, 470, 26);
    accessory_id = Array("S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8");
    closeAllMenuBars();
    selectedvehicle = 0; selectedspecial = 0; selectedaccesso = ""; thecar_discount = 0;
    updateAllPanels();
 }
 
 var login = false;
 if(uristring.indexOf("&LOGIN=") != -1 || uristring.indexOf("?LOGIN=") != -1) {
    Mode = parseInt(uristring.substr(uristring.indexOf("&LOGIN=") + uristring.indexOf("?LOGIN=") + 8, 1));
    if(Mode == 1) {
        login = true;
    }
 }
 
 function miLogoutClick() {
     miResetClick(); //reset everything
     $(function() {
        $( '#LoginPanel' ).dialog( 'open' );
    });
 }
 
 var dummyvarformyOptionsClick = false;
 function mOptionsClick() {
    if(dummyvarformyOptionsClick) {
        mOptionsClose();
    } else {
        mOptionsOpen();
    }
 }
 function mOptionsOpen() {
    dummyvarformyOptionsClick = true;
    document.getElementById('mOptions').getElementsByTagName('ul')[0].style.display = "block";
    mFileClose();
    mOrderClose();
    mHelpClose();
 }
 function mOptionsClose() {
    dummyvarformyOptionsClick = false;
    document.getElementById('mOptions').getElementsByTagName('ul')[0].style.display = "none";
 }
 function mOptionsMove() {
    if ( dummyvarformyFileClick || dummyvarformyOptionsClick || dummyvarformyOrderClick || dummyvarformyHelpClick ) {
      mOptionsOpen();
    }
 }
 
 function miVehiclesClick() {
    closeAllMenuBars();
    $(function() {
        $( '#VehiclesDialogPanel' ).dialog( 'open' );
    });
 }
 
 function miSpecialsClick() {
    closeAllMenuBars();
    $(function() {
        $( '#SpecialsTablePanel' ).dialog( 'open' );
    });
 }
 
 function miAccessoriesClick() {
    closeAllMenuBars();
    $(function() {
        $( '#AccessoryDialogPanel' ).dialog( 'open' );
    });
 }
 
 var dummyvarformyOrderClick = false;
 function mOrderClick() {
    if(dummyvarformyOrderClick) {
        mOrderClose();
    } else {
        mOrderOpen();
    }
 }
 function mOrderOpen() {
    dummyvarformyOrderClick = true;
    document.getElementById('mOrder').getElementsByTagName('ul')[0].style.display = "block";
    mFileClose();
    mOptionsClose();
    mHelpClose();
 }
 function mOrderClose() {
    dummyvarformyOrderClick = false;
    document.getElementById('mOrder').getElementsByTagName('ul')[0].style.display = "none";
 }
 function mOrderMove() {
    if(dummyvarformyFileClick || dummyvarformyOptionsClick || dummyvarformyOrderClick || dummyvarformyHelpClick) {
      mOrderOpen();
    }
 }
 
 function miViewOrderClick() {
    closeAllMenuBars();
    $(function() {
        $( '#ViewPurchaseOrderPanel' ).dialog( 'open' );
    });
 }
 
 function miSendOrderClick() {
    closeAllMenuBars();
    if (!newVersion) {
        $(function() {
            $( '#SendPurchaseOrderPanel' ).dialog( 'open' );
        });
    } else {
        $(function() {
            $( '#SendPurchaseOrderPanelNew' ).dialog( 'open' );
        });
    }
 }
 
 var dummyvarformyHelpClick = false;
 function mHelpClick() {
    if(dummyvarformyHelpClick) {
        mHelpClose();
    } else {
        mHelpOpen();
    }
 }
 function mHelpOpen() {
    dummyvarformyHelpClick = true;
    document.getElementById('mHelp').getElementsByTagName('ul')[0].style.display = "block";
    mFileClose();
    mOptionsClose();
    mOrderClose();
 }
 function mHelpClose() {
    dummyvarformyHelpClick = false;
    document.getElementById('mHelp').getElementsByTagName('ul')[0].style.display = "none";
 }
 function mHelpMove() {
    if(dummyvarformyFileClick || dummyvarformyOptionsClick || dummyvarformyOrderClick || dummyvarformyHelpClick) {
      mHelpOpen();
    }
 }
 
 function miInfoClick() {
    closeAllMenuBars();
    $(function() {
        $( '#InfoPanel' ).dialog( 'open' );
    });
 }
 
 var uristring = decodeURI(window.location.search.toUpperCase());
 var buggyVersion = false;
 if(uristring.indexOf("&BUGGY=") != -1 || uristring.indexOf("?BUGGY=") != -1) {
    Mode = parseInt(uristring.substr(uristring.indexOf("&BUGGY=") + uristring.indexOf("?BUGGY=") + 8, 1));
    if(Mode == 1) {
        buggyVersion = true;
    }
 }
 function miBuggyClick() {
    closeAllMenuBars();
    if(buggyVersion) {
        document.getElementById('miBuggy_menu').innerHTML = getLanguageStringbyIdStr("miBuggy");
    } else {
        document.getElementById('miBuggy_menu').innerHTML = "&#9143; " + getLanguageStringbyIdStr("miBuggy");
    }
    buggyVersion = !buggyVersion;
    updateAllPanels();
 }
 
 var newVersion = false;
 if(uristring.indexOf("&NEWVERSION=") != -1 || uristring.indexOf("?NEWVERSION=") != -1) {
    Mode = parseInt(uristring.substr(uristring.indexOf("&NEWVERSION=") + uristring.indexOf("?NEWVERSION=") + 13, 1));
    if(Mode == 1) {
        newVersion = true;
    }
 }
 function miNewVersionClick() {
    closeAllMenuBars();
    if(newVersion) {
        document.getElementById('miNewVersion_menu').innerHTML = getLanguageStringbyIdStr("miNewVersion");
    } else {
        document.getElementById('miNewVersion_menu').innerHTML = "&#9143; " + getLanguageStringbyIdStr("miNewVersion");
    }
    newVersion = !newVersion;
    if(newVersion) {
        document.getElementById('InfoIcon').src = "include/carConfigNew.png";
        document.getElementById('VehicleIdLabel').style.display = "inline";
        document.getElementById('VehicleId').style.display = "inline";
    }
    else {
        document.getElementById('InfoIcon').src = "include/carConfig.png";
        document.getElementById('VehicleIdLabel').style.display = "none";
        document.getElementById('VehicleId').style.display = "none";
        document.getElementById('AccessoryDiscountValue_input').style.display = "inline";
        document.querySelector("label[for='AccessoryDiscountValue']").style.display = "inline";
    }
    // update all elements to the "new" version
    updateAllPanels();
 }
 
 var loadTestVersion = false;
 if(uristring.indexOf("&LOADTEST=") != -1 || uristring.indexOf("?LOADTEST=") != -1) {
    loadTestMode = parseInt(uristring.substr(uristring.indexOf("&LOADTEST=") + uristring.indexOf("?LOADTEST=") + 11, 1));
    if(loadTestMode == 1) {
        loadTestVersion = true;
    }
 }
 function miLoadtestClick() {
    closeAllMenuBars();
    if(loadTestVersion) {
        document.getElementById('miLoadtest_menu').innerHTML = getLanguageStringbyIdStr("miLoadtest");
    } else {
        document.getElementById('miLoadtest_menu').innerHTML = "&#9143; " + getLanguageStringbyIdStr("miLoadtest");
    }
    loadTestVersion = !loadTestVersion;
    updateAllPanels();
 }
 
 var currentUser = "tester";
 if(uristring.indexOf("&USER=") != -1 || uristring.indexOf("?USER=") != -1) {     
    currentUser = uristring.substr(uristring.indexOf("&USER=") + uristring.indexOf("?USER=") + 7);
    var parts = currentUser.split("?")
    parts = parts[0].split("&")
    currentUser = parts[0]
 }
 
 function showOrderMenu()
 {
     if (currentUser == "USER") {
         document.getElementById('mOrder').style.display = "none";
     }
 }
 // }}}