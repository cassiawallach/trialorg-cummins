({
    doInit : function(component, event, helper) {
        helper.getsolsCompsHelper(component, event,helper);
        helper.getReplReasonLOVs(component, event, helper);       
        helper.getFailureCodes(component, event, helper);
    } ,
    //Added Ravi kanth Add Failure Component
    showfailurecomp:function(component, event, helper) {
        
        component.set("v.showAddfailure",true);
    },
    addfailurecomp:function(component, event, helper) {
               
        if((component.find('inptid').get('v.value') == null || component.find('inptid').get('v.value') == '')  && (component.find('cmfid').get('v.value') == null || component.find('cmfid').get('v.value') =='') ) {
            
            var staticLabel = $A.get("$Label.c.FSLFailureErrorMessageempty");
            component.set("v.displayerror" , staticLabel );
        }
        else if((component.find('inptid').get('v.value') != '' && component.find('inptid').get('v.value') !=null ) && (component.find('cmfid').get('v.value') != '' && component.find('cmfid').get('v.value') != null )) {
            
            var staticLabel = $A.get("$Label.c.FSLFailureErrorMessage");
            component.set("v.displayerror" , staticLabel );
        }
        else {
            component.set("v.showAddfailure",false);
            helper.insertsolutioncomp(component, event, helper);
        }
        
    },
    cancelmodelwindow:function(component, event, helper) {
        component.set("v.showAddfailure",false);
        
    },
    showCustParts:function(component, event, helper) {
        console.log('in show cust parts');
        component.set("v.addCustParts", true);
    },
    isRefreshed: function(component, event, helper) {
     //   location.reload();
    },// end Ravi Kanth
    reloadCustParts: function(component, event, helper) {
        //alert('event fired');
        var action2 = component.get("c.getCustParts");
        action2.setParams({
            'woId': component.get("v.recordId")
        });
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                component.set("v.cssPartsList",response.getReturnValue());
                var abc=component.get("v.cssPartsList");
                console.log('repair reason picklist values::'+abc.length);
            }
        });
        $A.enqueueAction(action2);
    },
    reloadData: function(component, event, helper) {
        console.log('***current row>'+component.get("v.currentRow"));
        console.log('***current row>'+component.get("v.selectedRowOnParent"));
        if(component.get("v.currentRow") == component.get("v.selectedRowOnParent"))
        {
            console.log('calling helper reloader');
            helper.getsolsCompsHelper(component, event,helper);
        }
        /*starts - changed by vinod yellala - 5-2*/
        var action2 = component.get("c.getCustParts");
        action2.setParams({
            'woId': component.get("v.recordId")
        });
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                component.set("v.cssPartsList",response.getReturnValue());
                var abc=component.get("v.cssPartsList");
                console.log('repair reason picklist values::'+abc.length);
            }
        });
        $A.enqueueAction(action2);
        /*ends - changed by vinod yellala - 5-2*/
        console.log('realoaded');
    },
    addSolCompsToEvt:function(component, event, helper) {
        /*var selectAllBox = component.find("checkboxNew").get("v.value").Name;
        console.log(selectAllBox);*/
        var selectedRows=[];
        var unselectedRows=[];
        selectedRows=component.get("v.selectedComps");
        unselectedRows=component.get("v.deSelectedComps");
 
        var row = event.getSource(); 
        console.log(row.get("v.value"));
        if(row.get("v.value") == true)
        {
            console.log('inside true:::'+selectedRows.indexOf(row.get("v.text")));
            //Added:Dinesh -- Starts
            
            var selectedparts=[];
        	selectedparts = component.get("v.selectedParts");
            if(typeof selectedparts === "undefined") 
            {
                console.log('initialized selectedparts');
                selectedparts=[];
            }
            
            var deSelectedParts=component.get("v.deSelectedParts");
            if(typeof deSelectedParts === "undefined"){
                console.log('initialized deSelectedParts'); 
                deSelectedParts=[];
            } 
            
            var selectcheck = component.find('checkboxNew');
            if(typeof selectcheck != "undefined"){
                console.log('selectcheck:: ',selectcheck);
                //If failure have only one parts then component.find return non-array attribute.
                if(Array.isArray(selectcheck) == false){
                    if(selectcheck.get("v.labelClass") == row.get("v.text")){
                        //Remove from selectedparts.
                        if(typeof selectedparts !== "undefined" && selectedparts.length > 0){
                            var indx = selectedparts.indexOf(selectcheck.get("v.text"));
                            console.log('row index>>'+indx);
                            if(indx > -1)
                                selectedparts.splice(indx,1);
                        }
                        
                        //Re-add in list. Add assigment = Primary to select only primary parts for a Failure.NIN-481-Trupthi 8/18/22
                        if(selectcheck[i].get("v.text").Assignment == 'Primary'){
                        selectcheck.set("v.value",true);
                        }
                        selectedparts.push(selectcheck.get("v.text"));
                    }
                }
                else{
                    for(var i=0; i<selectcheck.length; i++){
                        if(selectcheck[i].get("v.labelClass") == row.get("v.text")){
                            //Remove from selectedparts.
                            if(typeof selectedparts !== "undefined" && selectedparts.length > 0){
                                var indx = selectedparts.indexOf(selectcheck[i].get("v.text"));
                                console.log('row index>>'+indx);
                                if(indx > -1)
                                    selectedparts.splice(indx,1);
                               
                            }
                            //Add assigment = Primary to select only primary parts for a Failure.NIN-481-Trupthi 8/18/22
                            if(selectcheck[i].get("v.text").Assignment == 'Primary'){
                                selectcheck[i].set("v.value",true);                               
                            }
                            selectedparts.push(selectcheck[i].get("v.text"));
                        }

                    }
                }
            }
            console.log('selectedparts',selectedparts);
            var comps = [];
            comps = component.get("v.fuelCompsPartsABC");
            if(typeof comps != "undefined"){
                for(var i = 0; i< comps.length; i++)
                {
                    console.log('comp id in for loop::'+comps[i].compId);
                    if(comps[i].compId == row.get("v.text") && comps[i].selectedComp == false){
                        comps[i].selectedComp = true;
                    }                   
                }
            }
            component.set("v.fuelCompsPartsABC", comps);
            component.set("v.selectedParts",selectedparts);
        	component.set("v.deSelectedParts",deSelectedParts); 
            
            if(selectedRows.indexOf(row.get("v.text")) == -1)
                selectedRows.push(row.get("v.text"));
            //added on 8/12
            var indx = unselectedRows.indexOf(row.get("v.text"));
            console.log('row index>>'+indx);
            if(indx > -1)
                unselectedRows.splice(indx,1);
            
            console.log('Selected Parts :: '+selectedparts);
            console.log('deSelectedParts :: '+deSelectedParts);
            //Added:Dinesh -- Ends
        }
        else
        {            
            console.log('inside false'+row.get("v.text"));
            var indx = selectedRows.indexOf(row.get("v.text"));
            console.log('row index>>'+indx);
            var comps = [];
            comps = component.get("v.fuelCompsPartsABC");
            var selectedparts=[];
            selectedparts = component.get("v.selectedParts");
            var tempSelectedparts=[];
            var tempDeSelectedparts=[];
            var deSelectedParts=component.get("v.deSelectedParts");
            var selectedRows=[];
            var unselectedRows=[];
            selectedRows=component.get("v.selectedComps");
            unselectedRows=component.get("v.deSelectedComps");
            
            for(var i = 0; i< comps.length; i++)
            {
                console.log('comp id in for loop::'+comps[i].compId);
                console.log('checkbox flag::'+comps[i].selectedComp);
                if(comps[i].compId == row.get("v.text") && comps[i].selectedComp == false)
                {
                    var parts=[];
                    parts = comps[i].cssSoldOpts;
                    console.log('parts::'+parts.length);	
                    for(var j= 0; j< parts.length; j++)
                    {
                        var indx = selectedparts.indexOf(parts[j]);
                        console.log('row index>>'+indx);
                        /*if(indx > -1)
                            unselectedRows.splice(indx,1);
                        if(parts[j].selectedPart == true && indx > -1)
                        {
                            parts[j].selectedPart == false;
                            selectedRows.splice(indx,1);
                            unselectedRows.push(parts[j]);
                        }*/
                        console.log('parent for loop part id::'+parts[j].partOptId);
                        console.log('selectedparts::'+selectedparts.length);
                        if(selectedparts.length > 0)
                        {
                            for(var k=0; k<selectedparts.length; k++)
                            {
                                console.log('selected part id::'+selectedparts[k].partOptId);
                                console.log('selected part flag::'+selectedparts[k].selectedPart);
                                if(parts[j].partOptId == selectedparts[k].partOptId && selectedparts[k].selectedPart == true)
                                {
                                    console.log('unselecting part');
                                    parts[j].selectedPart=false; 
                                    tempDeSelectedparts.push(parts[j]);
                                    //unselectedRows.push(parts[j]);
                                }
                                else{
                                    if(tempSelectedparts.length > 0){
                                         if(tempSelectedparts.indexOf(selectedparts[k]) == -1)
                                            tempSelectedparts.push(selectedparts[k]);
                                    }
                                    else
                                        tempSelectedparts.push(selectedparts[k]);
                                } 
                                console.log('selected rows part id::'+selectedparts[k].partOptId);
                            }
                        }
                        else
                        {
                            parts[j].selectedPart=false; 
                            //unselectedRows.push(parts[j]);
                            tempDeSelectedparts.push(parts[j]);
                        }
                    }
                    comps[i].cssSoldOpts = parts;
                }
                
                    
            }
            component.set("v.fuelCompsPartsABC", comps);
            if(indx > -1)
                selectedRows.splice(indx,1);
            if(unselectedRows.indexOf(row.get("v.text")) == -1)
                unselectedRows.push(row.get("v.text"));     
            
            component.set("v.selectedParts",tempSelectedparts);
        	component.set("v.deSelectedParts",tempDeSelectedparts);
            console.log('after adding or removing>>'+selectedRows);
        	console.log('deselpart::'+tempDeSelectedparts);
        }
        
        component.set("v.selectedComps",selectedRows);
        component.set("v.deSelectedComps",unselectedRows);
        // alert(component.get("v.selectedComps"));
        console.log(component.get("v.selectedComps"));
        
        var cmpEvent = component.getEvent("AddSolComps");
        //Set event attribute value
        cmpEvent.setParams({"solComps" : component.get("v.selectedComps"),
                            "unselectedSolComps" : component.get("v.deSelectedComps"),
                            "selectedParts" : component.get("v.selectedParts"),
                            "deSelectedParts" : component.get("v.deSelectedParts"),
                            "cssSolComps":component.get("v.fuelCompsPartsABC")});
                                    ///"partIdReplsRsn":component.get("v.partReplRsnArr")});
        cmpEvent.fire();
        console.log('event fired');
        // Added by vinod for the selecting the parts and solution component
        if(selectedParts.get("v.value") == true){
             var selectedComps = true;
             
            
        }
         console.log('selectedComps >>'+selectedComps.length+'<>selectedParts length>'+selectedParts.length);
        /*
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        console.log('selected indx on child comp>>'+component.get("v.selectedIdx"));
        //Set event attribute value
        cmpEvent.setParams({"pickvalues" : picklistval,
                            "selectedIdx" : component.get("v.selectedIdx")});
        cmpEvent.fire(); */

    },
    addPartOptions:function(component, event, helper) 
    {
        var row = event.getSource(); 
        console.log(row.get("v.text"));
        console.log('labelClass>>'+row.get("v.labelClass"));
        var selectedCompId=row.get("v.labelClass");
        var selectedparts=[];
        selectedparts = component.get("v.selectedParts");
        var deSelectedParts=component.get("v.deSelectedParts");
        var selectedRows=[];
        var unselectedRows=[];
        selectedRows=component.get("v.selectedComps");
        unselectedRows=component.get("v.deSelectedComps");
        console.log('before if condition>>'+row.get("v.value"));
        console.log('selectedparts.length::'+selectedparts);
        console.log('deSelectedParts.length::'+deSelectedParts);
        if(typeof selectedparts === "undefined") 
        {
            console.log('initialized selectedparts');
            selectedparts=[];
        }
        if(typeof deSelectedParts === "undefined"){
            console.log('initialized deSelectedParts'); 
            deSelectedParts=[];
        } 
        if(row.get("v.value") == true)
        {
            selectedparts.push(row.get("v.text"));
            var comps = [];
            comps = component.get("v.fuelCompsPartsABC");
            for(var i = 0; i< comps.length; i++)
            {
                console.log('comp id in for loop::'+comps[i].compId);
                if(comps[i].compId == selectedCompId && comps[i].selectedComp == false)
                    comps[i].selectedComp = true;
            }
            component.set("v.fuelCompsPartsABC", comps);
            if(selectedRows.indexOf(selectedCompId) == -1)
                selectedRows.push(selectedCompId);
            //added on 8/12
            var indx = unselectedRows.indexOf(selectedCompId);
            console.log('row index>>'+indx);
            if(indx > -1)
                unselectedRows.splice(indx,1);
        }
        else
        {
            console.log('selectedparts.length::'+selectedparts);
            console.log('deSelectedParts.length::'+deSelectedParts);
            if(typeof selectedparts !== "undefined") console.log('undefined');
            if(typeof selectedparts !== "undefined" && selectedparts.length > 0)
            {
                var indx = selectedparts.indexOf(row.get("v.text"));
                console.log('row index>>'+indx);
                if(indx > -1)
                    selectedparts.splice(indx,1);
            }
            
            if(typeof deSelectedParts !== "undefined" && deSelectedParts.length > 0)
            {
                if(deSelectedParts.indexOf(row.get("v.text")) == -1)
                    deSelectedParts.push(row.get("v.text")); 
            }
            var comps = [];
            comps = component.get("v.fuelCompsPartsABC");
            for(var i = 0; i< comps.length; i++)
            {
                console.log('comp id in for loop::'+comps[i].compId);
                if(comps[i].compId == selectedCompId && comps[i].selectedComp == true)
                {
                    var parts=[];
                    parts = comps[i].cssSoldOpts;
                    var partSelected = false;
                    for(var j = 0; j < parts.length; j++)
                    {
                        if(parts[j].selectedPart == true)
                        {
                            partSelected=true;
                            break;
                        }
                    }
                    if(partSelected == false)
                        comps[i].selectedComp = false;
                }
            }
            component.set("v.fuelCompsPartsABC", comps);
            var indx = selectedRows.indexOf(selectedCompId);
            console.log('row index>>'+indx);
            if(indx > -1)
                selectedRows.splice(indx,1);
            if(unselectedRows.indexOf(selectedCompId) == -1)
                unselectedRows.push(selectedCompId);   
        }
        console.log('selectedparts>>'+selectedparts);
        component.set("v.selectedParts",selectedparts);
        component.set("v.deSelectedParts",deSelectedParts);        
        var cmpEvent = component.getEvent("AddSolComps");
        //var selectedRows=component.get("v.selectedComps");
        //var unselectedRows=component.get("v.deSelectedComps");
        //Set event attribute value
        cmpEvent.setParams({"solComps" : selectedRows,
                            "unselectedSolComps" : unselectedRows,
                            "selectedParts" : component.get("v.selectedParts"),
                            "deSelectedParts" : component.get("v.deSelectedParts"),
                            "cssSolComps":component.get("v.fuelCompsPartsABC")});
                                    //"partIdReplsRsn":component.get("v.partReplRsnArr")});
        cmpEvent.fire();
    },
    saveSolComps:function(component, event, helper) 
    {
        /*starts - changed by vinod yellala - 5-2*/
        var action2 = component.get("c.updateSolComps");
        action2.setParams({
            'solComps': component.get("v.selectedComps"),
            'selectedParts' : component.get("v.selectedParts")
        });
        action2.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if (state === "SUCCESS")
            {
                //component.set("v.cssPartsList",response.getReturnValue());
                //var abc=component.get("v.cssPartsList");
               // console.log('repair reason picklist values::'+abc.length);
            }
        });
        $A.enqueueAction(action2);
        /*ends - changed by vinod yellala - 5-2*/
    },
    assignSolComps:function(component, event, helper) 
    {
        var cmpEvent = component.getEvent("AddSolComps");
        cmpEvent.setParams({"solComps" : component.get("v.selectedComps"),
                            "unselectedSolComps" : component.get("v.deSelectedComps"),
                            "selectedParts" : component.get("v.selectedParts"),
                            "deSelectedParts" : component.get("v.deSelectedParts"), //changed to deSelectedParts by Sruthi 10/18/2021 - VGRS2-9
                            "cssSolComps":component.get("v.fuelCompsPartsABC")});
                                    //"partIdReplsRsn":component.get("v.partReplRsnArr")});
        cmpEvent.fire();
        console.log('event fired');
    },
    collectReplRsns:function(component, event, helper) 
    {
        /*var partId = event.getSource().get("v.messageWhenValueMissing");
        var replRsn = event.getSource().get("v.messageWhenValueMissing");
        var partReplRsnArr=[];
        console.log('partReplRsnArr>>'+partReplRsnArr);
        //partReplRsnArr.push({cspId:partId, replRsn:replRsn});
        partReplRsnArr=component.get("v.partReplRsnArr");
        console.log('partReplRsnArr>>'+partReplRsnArr);
        if(partReplRsnArr.length == 0)
            partReplRsnArr.push({cspId:partId, replRsn:replRsn}); 
        else{
            for( var key in partReplRsnArr)
            {
                console.log('key:::'+partReplRsnArr[key].cspId );
                console.log('index of::'+partReplRsnArr.indexOf(key) );
                if(partReplRsnArr.indexOf(key) == -1)//partReplRsnArr[key].cspId == partId)
                {
                    //console.log('inside for loop sym values::'+makeModelMap[key].maker);
                    partReplRsnArr[key].replRsn=replRsn;                
                    
                }
                else
                    partReplRsnArr.push({cspId:partId, replRsn:replRsn});  
            }
        }
        console.log(partReplRsnArr);
        component.set("v.partReplRsnArr",partReplRsnArr);
        */
        var cmpEvent = component.getEvent("AddSolComps");
        cmpEvent.setParams({"solComps" : component.get("v.selectedComps"),
                            "unselectedSolComps" : component.get("v.deSelectedComps"),
                            "selectedParts" : component.get("v.selectedParts"),
                            "deSelectedParts" : component.get("v.deSelectedParts"),
                            "cssSolComps":component.get("v.fuelCompsPartsABC")});
        //"partIdReplsRsn":component.get("v.partReplRsnArr")});
        cmpEvent.fire();
        console.log('event fired');
    },
    
    handleCompsHelper: function(component, event, helper) {
        console.log('calling parent get sol comp');
        helper.getsolsCompsHelper(component, event,helper);
    }
    
})