({
    //Get Related Docs
    doInit : function(component, event, helper) { 
        helper.getSOAssertId(component, event);  
        
        helper.fetchcoverageHelper(component, event, helper);
        helper.fetchcertificateHelper(component, event, helper);
    },


    handleEditBtn: function(cmp, event, helper) {
      
        cmp.set('v.editview', true );
        cmp.set('v.displayview', false );
    
    },

    handleCancelBtn: function(cmp, event, helper) {
      
        cmp.set('v.editview', false );
        cmp.set('v.displayview', true );
    
    },

    handleSaveBtn: function(component, event, helper) {

        component.find("assetForm").submit();

        component.set('v.editview', false ); 
        component.set('v.displayview', true );

        

    }

})