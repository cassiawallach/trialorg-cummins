import lookUp from '@salesforce/apex/EVL_LookupCompController.fetchLookUpValues';
import primaryLocation from '@salesforce/apex/EVL_LookupCompController.fetchUser';
import { api, LightningElement, track, wire } from 'lwc';
import evlsn from '@salesforce/label/c.EVL_SN';
import evlvin from '@salesforce/label/c.EVL_VIN';
import evlunit from '@salesforce/label/c.EVL_Unit';


export default class customLookUp extends LightningElement {
label= {
    evlsn, evlvin, evlunit
};
@api objName;
@api iconName;
@api filter = '';
@api searchPlaceholder='Search';
@track isAccount = false;

@track selectedName;
@track records;
@track isValueSelected;
@track blurTimeout;

@api optionSelected = '';
@track showOptions = false;
@api searchTerm;
@api radiovalue;
//css
@track boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
@track inputClass = '';

@wire(lookUp, {searchType : '$radiovalue', searchKeyWord : '$searchTerm', ObjectName : '$objName'})
wiredRecords({ error, data }) {
    if (data) {
        console.log('::: Anirudh Success2 - '+JSON.stringify(data));
        this.error = undefined;
        this.records = data;
        if(this.objName === 'Account') {
            this.isAccount = true;
        }
    } else if (error) {
        console.log('ANirudh Error');
        this.error = error;
        this.records = undefined;
    }
}


handleClick() {
    this.searchTerm = '';
    this.inputClass = 'slds-has-focus';
    this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus slds-is-open';
}

onBlur() {
    this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-has-focus'}, 300);
}

onSelect(event) {
    let selectedId = event.currentTarget.dataset.id;
    let selectedName = event.currentTarget.dataset.name;
    const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
    this.dispatchEvent(valueSelectedEvent);
    this.isValueSelected = true;
    this.selectedName = selectedName;
    if(this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';
}

connectedCallback() {
    console.log('Anirudh onload');    
    //Call Apex controller to pre populate accountId.
   if(this.objName === 'Account'){
    primaryLocation()
    .then(result => {
        console.log('onload', result);
        let selectedId = result.AccountId__c;
    let selectedName = result.AccountId__r.Name;
    const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  selectedId });
    this.dispatchEvent(valueSelectedEvent);
    this.isValueSelected = true;
    this.showOptions = true;
    this.selectedName = selectedName;
    if(this.blurTimeout) {
        clearTimeout(this.blurTimeout);
    }
    this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus';

    })
    .catch(error => {
        console.log('onload error', error)

    });
}
    }

handleRemovePill() {
    this.isValueSelected = false;
    console.log('Anirudh test');
    //added condition to remove asset when unselected- Piyush
    if(this.objName === 'Account' || this.objName === 'Asset'){ 
        this.searchTerm = '';
        // Creates the event with the data.
        const valueSelectedEvent = new CustomEvent('lookupselected', {detail:  '' });
            // Dispatches the event.
        this.dispatchEvent(valueSelectedEvent);
    }
}

onChange(event) {
    this.searchTerm = event.target.value;
    console.log('Event check'+event.target.value+':::::::::::::::::::::::'+this.searchTerm);
    /*CT1_144 changes*/
    const SearchValueEvent = new CustomEvent('searchedvalueselected', {detail: this.searchTerm});
    this.dispatchEvent(SearchValueEvent);
    console.log('::: After event');
    this.handleSearchChange();
}

handleSearchChange() {
    console.log('::: Handle Search Change called-'+this.radiovalue+' and searchTerm = '+this.searchTerm);
    lookUp({searchType : this.radiovalue, searchKeyWord : this.searchTerm, ObjectName : this.objName})
    .then(result => {
        console.log(':::: Data is - '+JSON.stringify(result));
        this.error = undefined;
        this.records = result;
    })
    .catch(error => {
        console.log(':::: Error is - '+JSON.stringify(error));
        this.error = error;
        this.records = undefined;
    });
}

get options() {
    return [
        { label: 'Asset/PSN', value: 'AssetNumber' },
        { label: 'VIN', value: 'VINNumber' },
        { label: 'Unit', value: 'UnitNumber' },
    ];
}


handleChange(event) {
    this.optionSelected = event.target.value; 
}

    handleRadioChange(event) {
        this.radiovalue = event.target.value;
        console.log(':::Radio Value = '+this.radiovalue);
    }

}