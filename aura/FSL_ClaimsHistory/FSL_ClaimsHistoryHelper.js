({
	getClaimsDetails : function(component, event, helper) {
		var targetRec = event.currentTarget;
        var claimNum = targetRec.getAttribute("data-claim");
        console.log('::: Claim Number = '+claimNum);
        component.set('v.claimNumber', claimNum);
    }
})