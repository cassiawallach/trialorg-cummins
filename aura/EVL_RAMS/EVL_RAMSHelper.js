({
	
  GetWebOrderId: function() {
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

                    if (tempKey == "TabId") {
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
}
    
})