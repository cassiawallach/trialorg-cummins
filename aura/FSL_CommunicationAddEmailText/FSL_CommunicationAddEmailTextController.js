({
    doInit : function(component, event, helper) {
        helper.doInit(component,event);
        
        // helper.loadLanguage(component,event);
        // helper.loadAllLanguages(component,event);
    },
    saveAddEmailText : function(component, event, helper) {
       /** var FSL_Email = component.get("v.FSL_Email"); 
        var splitEmail = FSL_Email.split(";"); 
        var isvalidEmail = true;
        for (var i=0; i < splitEmail.length; i++) {
            if(splitEmail[i] !='' && splitEmail[i].includes("@")==false){
               alert("Please Enter a Valid Email Address");
               isvalidEmail = false;
               return true;
                
            }
        }
        if(isvalidEmail==true){**/
            helper.saveEmailText(component,event);	
            var cmpDiv = component.find('textareaID');
            $A.util.removeClass(cmpDiv, 'changeStyleInEdit'); 
            var cmpDiv2 = component.find('pencilID');
            $A.util.removeClass(cmpDiv2, 'pencilIconOnMouseFocus');
            $A.util.addClass(cmpDiv2, 'pencilIcon');
        //}
       
    },  
    editEmailText : function(component, event, helper) {
        component.set("v.editEmailText",false);
        var cmpDiv = component.find('pencilID'); 
        $A.util.removeClass(cmpDiv, 'pencilIcon');
        $A.util.addClass(cmpDiv, 'pencilIcononfocus');
    },
    cancelChanges : function(component, event, helper){
        var FSL_Email2 = component.get("v.FSL_Email2");
        component.set("v.FSL_Email",FSL_Email2);
        component.set("v.editEmailText",true);
        var cmpDiv = component.find('textareaID');
        $A.util.removeClass(cmpDiv, 'changeStyleInEdit');
        var cmpDiv2 = component.find('pencilID'); 
        $A.util.removeClass(cmpDiv2, 'pencilIconOnMouseFocus');
        $A.util.removeClass(cmpDiv2, 'pencilIcononfocus');
        $A.util.addClass(cmpDiv2, 'pencilIcon');
        
    },
    ChangesTextArea : function(component, event, helper){
        var cmpDiv = component.find('textareaID');  
        $A.util.addClass(cmpDiv, 'changeStyleInEdit');
    },
    onfocusPencilIcon : function(component, event, helper){
        var cmpDiv = component.find('pencilID');
        $A.util.addClass(cmpDiv, 'pencilIconOnMouseFocus');
    },
    PencilIconClick : function(component, event, helper){
        var cmpDiv = component.find('pencilID');
        $A.util.addClass(cmpDiv, 'pencilIcononfocus');
    },
    
    onMovePencilIcon : function(component, event, helper){
        var cmpDiv2 = component.find('pencilID'); 
        $A.util.removeClass(cmpDiv2, 'pencilIconOnMouseFocus');
        $A.util.addClass(cmpDiv2, 'pencilIcon');
    },
})