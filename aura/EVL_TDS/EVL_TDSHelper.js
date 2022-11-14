({
	
  GetWebOrderId: function(FId) {
    console.log("Enter GetWebOrderId");

    var woId = "";

    var queryParams = location.search;
    var queryParamsStr = queryParams.replace("?", "");

    var arrQueryParams = queryParamsStr.split("&");
    console.log('after arrQueryParams');
    if (String(queryParamsStr).trim() != "") {	
        if (arrQueryParams.length > 0) {
            for (var i = 0; i < arrQueryParams.length; i++) {
                var arrQueryEntry = arrQueryParams[i].split("=");

                if (arrQueryEntry.length > 0) {
                    var tempKey = String(arrQueryEntry[0]).trim();
                    var tempVal = "";

                    if (tempKey == FId) {
                        woId = String(arrQueryEntry[1]).trim();
                        break;
                    }
                }
            }
        }
    }
    console.log('before GetWebOrderId return', woId);
    return woId;
},
    
    removeParam : function(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
    },
    //By Priyanka for VGRS2-15
    fetchUserDetails : function(component, event, helper) {
         var action = component.get("c.getUserDetails");        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var resp = response.getReturnValue();
             if(resp.isSuccess)
             {
                 if(resp.userDetails.UserRole !== null)
                 {
                 	var userRole = resp.userDetails.UserRole.Name;  
                 component.set('v.roleName', userRole);                 
                 console.log("userrole:" + userRole);     
                 }
             }                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
          });
        $A.enqueueAction(action);
    }
})