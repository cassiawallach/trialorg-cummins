import { LightningElement,api,wire, track } from 'lwc';
import createRSWClaim from '@salesforce/apex/EVL_WS_RSW.sendClaimInfoToRSW';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import webUrlAssetWO from '@salesforce/label/c.css_rsw_link';
import css_CreateClaims from '@salesforce/label/c.CSS_CreateClaims';
import ASSETID_FIELD from '@salesforce/schema/WorkOrder.Asset.Id';
import WONUMBER_FIELD from '@salesforce/schema/WorkOrder.WorkOrderNumber';

export default class EVL_RSWCreateClaim extends NavigationMixin(LightningElement) {
    @api recordId;
   @track WOdata; 
   @track label = {css_CreateClaims};

    @wire(getRecord, { recordId: '$recordId', fields : [ASSETID_FIELD, WONUMBER_FIELD] }) 
    requete({error, data}){ if(data){ 
        this.WOdata = data; 
    }else if(error){ console.log('requete error', JSON.stringify(error));  } }
    get assetId() {
        return getFieldValue(this.WOdata, ASSETID_FIELD);
        }
		
		get woNumber() {
        return getFieldValue(this.WOdata, WONUMBER_FIELD);
        } 
    
createClaim(){
    console.log('>>>>>',this.recordId);
    createRSWClaim({ wId: this.recordId
     })
    .then(result => {
        console.log('buttonClicked abcde -> newresult', this.assetId);
        console.log('Anirudh after result');
		if(this.assetId){
			this.navigateToWebUrlPageAssetWO();
		}
        else{
            this.navigateToWebUrlPage();
        }
        
    })
    .catch(error => {
        console.log('TCL: dseContactManagementForSelectedAccountLwc -> buttonClicked -> error', error.value)
    });
}
navigateToWebUrlPage() {
    // Navigate to a URL
    console.log('insideNavigationmethod test');
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: webUrlAssetWO
        }
    },
    true // Replaces the current page in your browser history with the URL
  );
}

navigateToWebUrlPageAssetWO() {
    // Navigate to a URL
    console.log('insideNavigationmethod3');
    this[NavigationMixin.Navigate]({
        type: 'standard__webPage',
        attributes: {
            url: webUrlAssetWO+this.woNumber
        }
    },
    true // Replaces the current page in your browser history with the URL
  );
}
}