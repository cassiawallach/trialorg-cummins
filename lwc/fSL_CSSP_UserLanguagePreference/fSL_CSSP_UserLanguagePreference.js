import { LightningElement, wire, track, api } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateUser from '@salesforce/apex/FSL_CSSP_UserLanguagePreference.updateUser';
import USER_ID from '@salesforce/user/Id';
import LANG_FIELD from '@salesforce/schema/User.LanguageLocaleKey';
import userinfohelptext from '@salesforce/label/c.FSL_Guidanz_UseInfo_HelpText';
import LanguagePref from '@salesforce/label/c.FSL_CSSP_Customer_LagPref';
import SaveLabel from '@salesforce/label/c.FSL_CSSP_Save';

export default class FSL_CSSP_UserLanguagePreference extends LightningElement {
    label = {
        userinfohelptext,
        LanguagePref,
        SaveLabel
    };
    // @api selStatus;
    @track error ;
    @track langPref_key;
    @api sValue;

    /* To get the saved language on load */
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [LANG_FIELD]
    }) wireuser({ error, data }) {
        if (error) {
           this.error = error;
        } else if (data) {
            //assign already saved language to a local variable
            this.langPref_key = data.fields.LanguageLocaleKey.value;
            this.sValue = this.langPref_key;
            console.log('lang pref: ', this.langPref_key);
        }
    }

    /* To assign value to the UI variable  
    get sValue() {
        return this.langPref_key;
    } */

    /* To get the current language selection from the UI onChange event of dropdown and store it in local variable */
    handleChange(event) {
        const selectedOption = event.detail.value;
        this.langPref_key = selectedOption;
    }

    /* To set select options for the picklist*/
    get statusOptions() {
        return [
            { label: 'English', value: 'en_US' },
            { label: 'French', value: 'fr' },
        ];
    }

    /* To perform save action on clicking the save button */
    saveUser() {
        let selectedStatus = this.langPref_key;
        console.log('save:', selectedStatus);
        console.log('USER_ID:', USER_ID);
        //call apex method & pass arguments
        updateUser({userId: USER_ID, langPref: this.langPref_key})
            .then(result => {
                console.log('result:', result);
                this.error = undefined;
                //throw proper response on success or apex error
                if(result) {
                    this.showToast('',result, 'error');           
                } else {
                    this.showToast('','Saved', 'success');
                    window.location.reload();
                }
            })
            .catch(error => {
                this.error = error.body.message;
                this.showToast('',this.error, 'error');           
            });
    }

    /* To show messages as Toast */
    showToast(title, message, variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}