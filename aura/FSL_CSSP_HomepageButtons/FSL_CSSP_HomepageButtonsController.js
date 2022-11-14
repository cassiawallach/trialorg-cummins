({
    inServiceClick : function (cmp, event, helper) {
        var btnLabl = event.getSource().get("v.name");
        cmp.set("v.buttonName", btnLabl);
        var inserTar=cmp.find('InSrv');
        var SerReqTar=cmp.find('SerReq');
        var AcReqTar=cmp.find('AcReq');
        var SerHstryTar=cmp.find('SerHstry');
        cmp.set("v.headerLabel",'');
        
        var elements = document.getElementsByClassName("Headerlabelclass");
        elements[0].style.display = 'none';
        
        $A.util.addClass(inserTar,'homeStyleBtnDark');
        $A.util.removeClass(SerReqTar,'homeStyleBtnDark');
        $A.util.removeClass(AcReqTar,'homeStyleBtnDark');
        $A.util.removeClass(SerHstryTar,'homeStyleBtnDark');
    },
    
    serviceRequestClick : function (cmp, event, helper) {
        var btnLabl = event.getSource().get("v.name");
        cmp.set("v.buttonName", btnLabl);
        var inserTar=cmp.find('InSrv');
        var SerReqTar=cmp.find('SerReq');
        var AcReqTar=cmp.find('AcReq');
        var SerHstryTar=cmp.find('SerHstry');
        var elements = document.getElementsByClassName("Headerlabelclass");
        elements[0].style.display = 'none';
        
        $A.util.removeClass(inserTar,'homeStyleBtnDark');
        $A.util.addClass(SerReqTar,'homeStyleBtnDark');
        $A.util.removeClass(AcReqTar,'homeStyleBtnDark');
        $A.util.removeClass(SerHstryTar,'homeStyleBtnDark');
    },
    
    actionRequiredClick : function (cmp, event, helper) {
        var btnLabl = event.getSource().get("v.name");
        cmp.set("v.buttonName", btnLabl);
        var inserTar=cmp.find('InSrv');
        var SerReqTar=cmp.find('SerReq');
        var AcReqTar=cmp.find('AcReq');
        var SerHstryTar=cmp.find('SerHstry');
        
        var elements = document.getElementsByClassName("Headerlabelclass");
        elements[0].style.display = 'none';
        
        $A.util.removeClass(inserTar,'homeStyleBtnDark');
        $A.util.removeClass(SerReqTar,'homeStyleBtnDark');
        $A.util.addClass(AcReqTar,'homeStyleBtnDark');
        $A.util.removeClass(SerHstryTar,'homeStyleBtnDark');
    },
    
    serviceHistoryClick : function (cmp, event, helper) {
        var btnLabl = event.getSource().get("v.name");
        cmp.set("v.buttonName", btnLabl);
        var inserTar=cmp.find('InSrv');
        var SerReqTar=cmp.find('SerReq');
        var AcReqTar=cmp.find('AcReq');
        var SerHstryTar=cmp.find('SerHstry');
        
        var elements = document.getElementsByClassName("Headerlabelclass");
        elements[0].style.display = 'none';
        
        $A.util.removeClass(inserTar,'homeStyleBtnDark');
        $A.util.removeClass(SerReqTar,'homeStyleBtnDark');
        $A.util.removeClass(AcReqTar,'homeStyleBtnDark');
        $A.util.addClass(SerHstryTar,'homeStyleBtnDark');
    },
    
    getInServicelabelFromLwc : function(component, event, helper) {
        var fSLInserviceLWC = component.get("v.fSLInserviceLWC");
        if(fSLInserviceLWC==false){
            component.set("v.InServicelabel",event.getParam('value'));
            component.set("v.buttonName","");
            component.set("v.fSLInserviceLWC",true);
        }
    },
    
    getServiceRequestslabelFromLwc : function(component, event, helper) {
        var fSLserviceRequestsLWC = component.get("v.fSLserviceRequestsLWC");
        if(fSLserviceRequestsLWC==false){
            component.set("v.ServiceRequestslabel",event.getParam('value'));
            component.set("v.buttonName","");
            component.set("v.fSLserviceRequestsLWC",true);
        }
    },
    
    getActionRequiredlabelFromLwc : function(component, event, helper) {
        var fSLActionRequiredLWC = component.get("v.fSLActionRequiredLWC");
        if(fSLActionRequiredLWC==false){
            component.set("v.ActionRequiredlabel",event.getParam('value'));
            component.set("v.buttonName","");
            component.set("v.fSLActionRequiredLWC",true);
        }
    },
    
    getServiceHistorylabelFromLwc : function(component, event, helper) {
        var fSLServiceHistoryLWC = component.get("v.fSLServieHLWC");
        if(fSLServiceHistoryLWC==false){
            component.set("v.ServiceHistorylabel",event.getParam('value'));
            component.set("v.buttonName","");
            component.set("v.fSLServieHLWC",true);
        }
    },
    doInit: function(component, event, helper) {
        component.set('v.ServiceRequestslabel',$A.get("$Label.c.FSL_Service_Requests")+ ' | 0');
        component.set('v.InServicelabel',$A.get("$Label.c.FSL_In_Service")+ ' | 0');
        component.set('v.ActionRequiredlabel',$A.get("$Label.c.css_action_required")+ ' | 0');
        component.set('v.ServiceHistorylabel',$A.get("$Label.c.CSS_Service_History")+ ' | 0');
      }
});