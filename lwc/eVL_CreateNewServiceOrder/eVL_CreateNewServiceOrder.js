//import GetUserProfile from '@salesforce/apex/EVL_CreateNewServiceOrder.getUserDetails';//added By Devon
import { LightningElement,track} from 'lwc';//added [wire,api] by Devon
import savePopup from '@salesforce/apex/EVL_LookupCompController.saveServiceOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import EVL_SO_Creation_Asset_Note from '@salesforce/label/c.EVL_SO_Creation_Asset_Note';
import EVL_SO_PH_validation from '@salesforce/label/c.EVL_SO_PH_validation';
import EVL_SO_PM_validation from '@salesforce/label/c.EVL_SO_PM_validation';
import EVL_PH_Helptext from '@salesforce/label/c.EVL_PH_Helptext';
import EVL_SO_Asset_validation from '@salesforce/label/c.EVL_SO_Asset_validation';
import EVL_Create_Service_Order from '@salesforce/label/c.EVL_Create_Service_Order';
import EVL_Create_New_Service_Order from '@salesforce/label/c.EVL_Create_New_Service_Order';
import EVL_Select_Search_Type from '@salesforce/label/c.EVL_Select_Search_Type';
import CSS_Contact_Name from '@salesforce/label/c.CSS_Contact_Name';
import css_customer from '@salesforce/label/c.css_customer';
import CSS_Customer_Complaint from '@salesforce/label/c.CSS_Customer_Complaint';
import EVL_Shop_Work_Order from '@salesforce/label/c.EVL_Shop_Work_Order';
import EVL_Product_Hours from '@salesforce/label/c.EVL_Product_Hours';
import EVL_product_Mileage from '@salesforce/label/c.EVL_product_Mileage';
import FSL_CSSP_Save from '@salesforce/label/c.FSL_CSSP_Save';
import Evl_Asset from '@salesforce/label/c.Evl_Asset';
import EVL_Close from '@salesforce/label/c.EVL_Close';
import EVL_Account from '@salesforce/label/c.EVL_Account';
import FSL_CSSP_Mileage_Measure from '@salesforce/label/c.FSL_CSSP_Mileage_Measure';
import EVL_Asset_PSN_Description from '@salesforce/label/c.EVL_Asset_PSN_Description';
import FSL_Special_Characters_Error from '@salesforce/label/c.FSL_Special_Characters_Error';
import FSL_Error from '@salesforce/label/c.FSL_Error';

export default class ModalLwc extends NavigationMixin(LightningElement) {
     @track bShowModal = false;
     @track Account = '';
     @track Asset = '';
     @track ConName = '';
     @track Customer = '';
     @track CusCom = '';
     @track shopWrkOrd = '';
     @track ProductHrs = '';
     @track ProductMil = '';
     @track MilMeas = 'Miles';
     @track SearchAsset = ''; /*CT1_144 changes*/
     @track SearchAccount;
     @track label = {EVL_SO_Creation_Asset_Note,EVL_SO_PH_validation,EVL_SO_PM_validation,EVL_PH_Helptext,EVL_SO_Asset_validation,EVL_Create_Service_Order,EVL_Create_New_Service_Order,EVL_Select_Search_Type,CSS_Contact_Name,css_customer,CSS_Customer_Complaint,EVL_Shop_Work_Order,EVL_Product_Hours,EVL_product_Mileage,FSL_CSSP_Save,Evl_Asset,EVL_Close,EVL_Account,FSL_CSSP_Mileage_Measure,EVL_Asset_PSN_Description};
     @track AssetSearchType = '';
     @track radiovalue = 'AssetNumber';


     loaded = true;
        
    handleAccountSelection(event){
        console.log("::: the selected record id is"+event.detail);
        this.Account = event.detail;
    }
    handleAssetSelection(event){
        console.log("the selected Asset id is in parent"+event.detail);
        this.Asset = event.detail;
    }
//added for CT1- 729- Piyush
    handleAssetOnBlur(event) {
        this.blurTimeout = setTimeout(() =>  {this.boxClass = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-has-focus'}, 300);
    }

    handleAssetSearchType(event){
        console.log("the selected Asset id is"+event.detail);
        this.AssetSearchType = event.detail;
    }

    /*CT1_144 changes*/
    handleSearchedvalue(event){
        this.SearchAsset = event.detail;
        console.log(this.SearchAsset+"the selected Asset id is"+event.detail);
    }

    handleAccountSearchedvalue(event){
        this.SearchAccount = event.detail;
        console.log(" the selected Asset id is = "+this.SearchAccount);
    }


    handleChange(event) {
        const field = event.target.name;
        if (field === 'ContactName') {
            this.ConName = event.target.value;
        } else if (field === 'Customer') {
            this.Customer = event.target.value;
        }else if (field === 'CustomerComplaint') {
            this.CusCom = event.target.value;
            if (this.CusCom.includes('  ')){
                console.log(this.CusCom);
            }
        }else if (field === 'ShopWorkOrder') {
            this.shopWrkOrd = event.target.value;
        //logic added for NIN-118
        }else if (field === 'ProductHours') {
            if(event.target.value === ''){
                this.ProductHrs = '';
            }else{
                this.ProductHrs = Math.floor(Number(event.target.value) *10)/10;
            }
        }else if (field === 'ProductMileage') {
            if(event.target.value === ''){
                this.ProductMil = '';
            }else{
                this.ProductMil = Math.ceil(Number(event.target.value));
            }     // end of NIN-118 changes       
        }else if (field === 'MileageMeasure') {
            this.MilMeas = event.target.value;
        }
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'Please enter required values',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
    /*CT1_144 changes*/
    showWarningToast(){
        const evt = new ShowToastEvent({
            title: 'Error',
            message: 'An invalid option has been choosen',
            variant: 'error',
            mode: 'dismissable'
    });
    this.dispatchEvent(evt);

    }
    
    showWarningAssetToast(){       
        const evt = new ShowToastEvent({
            title: 'Error',           
           message: EVL_SO_Asset_validation,
            variant: 'error',
            mode: 'dismissable'
    });
    this.dispatchEvent(evt);

    }
    //Adam changes for NIN-498 
    showBadCharacterToast(){       
        const evt = new ShowToastEvent({
            title: FSL_Error,           
           message: FSL_Special_Characters_Error,
            variant: 'error',
            mode: 'dismissable'
    });
    this.dispatchEvent(evt);

    }//End Changes

    openModal() {    
        // to open modal window set 'bShowModal' tarck value as true
        this.bShowModal = true;
    }

    savePopup(){
        const isInputsCorrect = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
        if (isInputsCorrect) {
        
        this.loaded = false;

        console.log(this.SearchAsset+'???????????????'+this.Asset+'this.Customer>>>>'+this.Customer+'this.shopWrkOrd'+this.shopWrkOrd+'this.Account'+this.Account);
       if (this.Customer === '' || this.shopWrkOrd === '' || this.Account === '') {
            this.showErrorToast();
            this.loaded = true;
            /*CT1_144 changes*/
        //Changes for NIN-498    
        }else if(this.CusCom.includes('	')){
            this.showBadCharacterToast();            
            this.loaded = true;
            console.log(this.CusCom);
        //End Changes
         }else{
            console.log('Account'+this.Account);
            savePopup({ AccountIdd: this.Account,
                AssetIdd: this.Asset,
                ContactNam: this.ConName,
                Cus: this.Customer,
                CusComp: this.CusCom,
                shpWrkOrd: this.shopWrkOrd,
                PrdctHrs: this.ProductHrs,
                PrdctMil: this.ProductMil,
                MilMes: this.MilMeas
             })
            .then(result => {
                setTimeout(() => {
                    this.loaded = true;
                    console.log('TCL: dseContactManagementForSelectedAccountLwc -> buttonClicked -> result', result),
                    console.log('Anirudh after result'),
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                        recordId : result.Id, 
                            actionName: 'view',  //Valid values include clone, edit, and view.
                            objectApiName: 'WorkOrder'
                        },
                    })
                }, 10000);
                
    
            })
            .catch(error => {
                console.log('TCL: dseContactManagementForSelectedAccountLwc -> buttonClicked -> error', error.value)
    
            });
            //Assigning blank values to variables after saving
            this.Account = '';
            this.Asset = '';
            this.ConName = '';
            this.Customer = '';
            this.CusCom = '';
            this.shopWrkOrd = '';
            this.ProductHrs = '';
            this.ProductMil = '';
            this.MilMeas = '';
        }
     }
     else{
        this.showWarningToast();
     }
    }
    closeModal() {    
        // to close modal window set 'bShowModal' tarck value as false
        console.log('Before this.Customer'+this.Customer+'this.shopWrkOrd'+this.shopWrkOrd);
         this.bShowModal = false;
         this.Account = '';
         this.Asset = '';
         this.ConName = '';
         this.Customer = '';
         this.CusCom = '';
         this.shopWrkOrd = '';
         this.ProductHrs = '';
         this.ProductMil = '';
         this.MilMeas = '';
         console.log('After this.Customer'+this.Customer+'this.shopWrkOrd'+this.shopWrkOrd);
    }
    /* javaScipt functions end */ 

    get options() {
        return [
            { label: 'Asset/PSN', value: 'AssetNumber' },
            { label: 'VIN', value: 'VINNumber' },
            { label: 'Unit', value: 'UnitNumber' },
        ];
    }

    handleRadioChange(event) {
        this.radiovalue = event.target.value;
        console.log(':::Radio Value = '+this.radiovalue);
    }

}