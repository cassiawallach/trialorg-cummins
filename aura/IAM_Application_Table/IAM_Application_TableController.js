({
    doInit : function(component, event, helper) {
        var key = component.get("v.key");
        var map = component.get("v.map");
        var arrayMapKeys = [];
        var Result=map[key];
        for(var i=0;i<Result.length;i++){
           //alert(Result[i]);
            arrayMapKeys.push({label:Result[i],value: Result[i]} );
        }
        //alert('before component set'+map[key])
        component.set("v.value" , arrayMapKeys);
    },
     checkboxHandler: function (cmp, event, helper) { 
         var oldValue= event.getParam("oldValue");
         var newValue = event.getParam("value");
         
        console.log('printg applicatin name'+cmp.get("V.key"));
         console.log('oldValue'+oldValue+'oldValue');
         console.log('newValue'+newValue+'newValue');
         console.log('mmmmmm'+JSON.stringify(oldValue)+'mmmmmmmm');
        
         //Checking the old valu and new value of checkbox field to invoke a component event
         if( (!$A.util.isEmpty(newValue)) && ($A.util.isEmpty(oldValue) ) )
         {
             //adding new values to map to call another function
              
             
             console.log('xxxxxx'+newValue+'xxxxxxxx'+oldValue+'xxxxxxxx');
             var cmpEvent = cmp.getEvent("cmpEvent");
             cmpEvent.setParams({
               "IsIncrease" :"true",
             "pushChosenValue" :"false"});
             cmpEvent.fire();
            
         }
         else if( $A.util.isEmpty(newValue) && !$A.util.isEmpty(oldValue))
         {
             
             console.log('Decrease'+newValue+'Decrease'+oldValue+'Decrease');
             var cmpEvent = cmp.getEvent("cmpEvent");
             cmpEvent.setParams({
               "IsIncrease" :"false",
             "pushChosenValue" :"false"});
             cmpEvent.fire();
             
         }
        
         var cmEvent = cmp.getEvent("cmEvent");
             cmEvent.setParams({
               "oldValue" :oldValue,
             "newValue" :newValue,
                 "Key":cmp.get("V.key")});
             cmEvent.fire();
   },
    
    RefreshValue: function (cmp, event, helper) { 
        
        if(event.getParam("isRefreshAndNotSave")=="true")
        {
           cmp.set("v.Choosen",cmp.get("v.BlankValue"));
           console.log('Refreshing'); 
           cmp.set("v.pushChosenValue","true");
        }else{
            var cmpEvent = cmp.getEvent("cmpEvent");
            console.log('Not refreshing');
             cmpEvent.setParams({
               "pushChosenValue" :"true" ,
               "ChosenValue":cmp.get("v.Choosen")
             });
             cmpEvent.fire();
            
        }
       
        
        
    }
    
    
   
	
})