({
    doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        //alert(karthik);
        // console.log(kkk>>>);
        // Code for NIN-34
        const values = [
            {'label': $A.get("$Label.c.CG_Check_Warranty_Coverage"), 'value': 'Checkwarrycoverage' },                                           
            {'label': $A.get("$Label.c.EVL_Claim_History"), 'value': 'ClaimHis' },
            {'label': $A.get("$Label.c.CSS_Service_History"), 'value': 'ServiceHis' },
            {'label': $A.get("$Label.c.CSS_Helpful_Resource"), 'value': 'HelpRes' }
        ];
        
        component.set('v.options', values);
         //start: updated by Trupthi, NIN-47 Date:2/23/2022 
        helper.getSessionPSN(component, event, helper);
        //helper.psnChangeSession(component, event, helper);
        component.set('v.radioValue', 'Checkwarrycoverage');
          //updated by Trupthi, NIN-47 Date:2/23/2022 -END
    },
    
    onSearch:function(component, event, helper) {
        var val = component.find("mygroup").get("v.value");
        component.set("v.SelectedRadioval",val);
          var seledRad = component.get("v.SelectedRadioval");
    if(seledRad == 'Checkwarrycoverage' || seledRad == undefined){
            console.log('karthikinsideeee>>>'+seledRad);
            var childCmp = component.find("CWComp");
            console.log('testinsidekarthik'+childCmp);
            childCmp.sampleMethod();
            console.log('testoutsidekarthik');
        }
        
        if(seledRad == 'ClaimHis'){
            var childCmp1 = component.find("CHComp");
            console.log('testinsidekarthikchildCmp1')
            childCmp1.sampleMethodCH(true);
            console.log('testoutsidekarthikchildCmp')
            
        }
         if(seledRad == 'ServiceHis'){
            var childCmp1 = component.find("SHComp");
            console.log('testinsidekarthikchildCmp1HR')
            childCmp1.sampleMethodSH(true);
             console.log('control waps')
            childCmp1.passPSNValue(component.get('v.psnValuetop'));
             console.log('control waps2')
            console.log('testoutsidekarthikchildCmpHR')
            
        }
          if(seledRad == 'HelpRes'){
            var childCmp1 = component.find("HRComp");
            console.log('testinsidekarthikchildCmp1HR')
            childCmp1.sampleMethodHR(true);
            console.log('testoutsidekarthikchildCmpHR')
            
        }
    },
    handleChange : function(component, event, helper) {
        var val = event.getSource().get("v.value");
        component.set("v.SelectedRadioval",val);
        console.log('val',val);
        if(val == 'ClaimHis'){
            var childCmp1 = component.find("CHComp");
            console.log('testinsidekarthikchildCmp1');
            console.log('childCmp1'+childCmp1);
            childCmp1.sampleMethodCH();
            console.log('testoutsidekarthikchildCmp>>>>');
        }
        if(val == 'Checkwarrycoverage'){
            var childCmp = component.find("CWComp");
            console.log('testinsidekarthik');
            childCmp.sampleMethod();
            console.log('testoutsidekarthik');
        }
          if(val == 'ServiceHis'){
            var childCmp1 = component.find("SHComp");
            console.log('testinsidekarthikchildCmp1HR')
            childCmp1.sampleMethodSH();
            console.log('testoutsidekarthikchildCmpHR')
            
        } 
         if(val == 'HelpRes'){
             //alert('val'+val);
            var childCmp1 = component.find("HRComp");
            console.log('testinsidekarthikchildCmp1HR')
            childCmp1.sampleMethodHR();
            console.log('testoutsidekarthikchildCmpHR')
            
        }
    },
    
    
    psnChange : function(component, event, helper) {
        // var val1 =  component.get("val");
        var seledRad = component.get("v.SelectedRadioval");
        console.log('seledRad>>>'+seledRad);
        if(seledRad == 'Checkwarrycoverage' || seledRad == undefined){
            console.log('karthikinsideeee>>>'+seledRad);
            var childCmp = component.find("CWComp");
            console.log('testinsidekarthik'+childCmp);
            childCmp.sampleMethod(true);
            console.log('testoutsidekarthik');
        }
        
        if(seledRad == 'ClaimHis'){
            var childCmp1 = component.find("CHComp");
            console.log('testinsidekarthikchildCmp1')
            //childCmp1.sampleMethodCH();
            console.log('testoutsidekarthikchildCmp')
            
        }
         if(seledRad == 'ServiceHis'){
            var childCmp1 = component.find("SHComp");
            console.log('testinsidekarthikchildCmp1HR')
            //childCmp1.sampleMethodSH();
            console.log('testoutsidekarthikchildCmpHR')
            
        }
          if(seledRad == 'HelpRes'){
            var childCmp1 = component.find("HRComp");
            console.log('testinsidekarthikchildCmp1HR')
            //childCmp1.sampleMethodHR();
            console.log('testoutsidekarthikchildCmpHR')
            
        }
    },
      
})