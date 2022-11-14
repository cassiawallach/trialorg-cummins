({
    
    doInit : function(component,event) {
		
        var action = component.get('c.fetchEmailTextData');
        var recordId = component.get('v.recordId');
        console.log('workOrder Id communication '+recordId);
        action.setParams({
            "woId" : recordId
        });
        
        action.setCallback(this,function(response){
            
            var status = response.getState();
            console.log('load status '+status+'rec Id '+recordId);
            if(status == "SUCCESS"){
                var emailText = [];
                emailText = response.getReturnValue();
                
                console.log('Response Data '+response.getReturnValue());
                console.log('Email Data '+emailText);
                console.log('Email One '+emailText[0]);
                console.log('Email two '+emailText[1]);
                
                if(emailText[0] != null && emailText[0] != ''){
                    component.set('v.FSL_Email',emailText[0]);
                    component.set('v.FSL_Email2',emailText[0]);
                    console.log('email '+component.get('v.FSL_Email'));
                }
                
                if(emailText[1] != null && emailText[1] != ''){
                    component.set('v.FSL_Text',emailText[1]);
                }
                
               /* if(emailText[2] != null && emailText[2] != ''){
                     component.set('v.selLanguage',emailText[2]);
                }*/
            }
        });
        $A.enqueueAction(action);
	},
   /* loadAllLanguages : function(component,event){
        
       var action =  component.get('c.getLangPref');
        action.setCallback(this,function(response){
            
            var state = response.getState();
            var lanValues = [];
            if(state == 'SUCCESS'){
               lanValues.push(response.getReturnValue());
               console.log('lang values '+lanValues);
               component.set('v.LangPreferences',lanValues);
                var langData = component.get('v.LangPreferences');
              console.log('Data v '+langData);
            }
            
        });
       $A.enqueueAction(action);
    },
    loadLanguage : function(component,event){
        
        var action = component.get('c.fetchLanguagePref');
        var recordId = component.get('v.recordId');
        action.setParams({
           "woId" : recordId 
        });
        
        action.setCallback(this,function(response){
            
            var status = response.getState();
            console.log('status '+status);
            var responseVal = response.getReturnValue();
            console.log('response Data '+ responseVal);
            
            component.set('v.selLanguage',responseVal);
            
        });
        
        $A.enqueueAction(action);
    },*/
	saveEmailText : function(component,event) {

        var emailData = component.get('v.FSL_Email');
        component.set("v.FSL_Email2",emailData);
        var textData = component.get('v.FSL_Text');
        
        if(emailData != '' || textData != '' || emailData != undefined || textData != undefined ){
           component.set("v.editEmailText",true);
          /*  var tosEvEmailText = $A.get("e.force:showToast");
            tosEvEmailText.setParams({
                message: 'Additional Email and Text are missing',
                type: 'error',
            });
            tosEvEmailText.fire();*/
            
            var action = component.get('c.saveEmailTextData');
            action.setParams({
                "woId":component.get('v.recordId'),
                "EmailInfo":component.get('v.FSL_Email'),
                "TextInfo":component.get('v.FSL_Text')
            });
            action.setCallback(this,function(response){
                var resState = response.getState();
                if(resState == "SUCCESS"){
                    var resToast = $A.get("e.force:showToast");
                    if(response.getReturnValue() == true){
                        resToast.setParams({
                            "type": "Success",
                            "message":"Data Saved Successfully"
                        });
                        resToast.fire();
                    }else{
                        resToast.setParams({
                            "type": "Error",
                            "message":"Failed to save the data"
                        });
                        resToast.fire();
                    }
                }
            });
            $A.enqueueAction(action);
            
        }
	}
})