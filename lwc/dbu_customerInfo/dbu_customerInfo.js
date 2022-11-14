import {
    LightningElement,
    wire,
    track,
    api
} from 'lwc';
// import fetchCustomerInfoDetails from '@salesforce/apex/dbu_CustomerInfoDetailsCtrl.fetchCustomerInfoDetails';
import fetchUserInfoDetails from '@salesforce/apex/dbu_CustomerInfoDetailsCtrl.fetchUserInfoDetails';
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';
import ManagePasswordtxt from '@salesforce/label/c.dbu_Manage_Password';
import Changepasswordtxt from '@salesforce/label/c.dbu_change_password';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import ID_FIELD from '@salesforce/schema/Contact.Id';
import companyname_FIELD from '@salesforce/schema/Contact.dbu_Company_Name__c';
import firstname_FIELD from '@salesforce/schema/Contact.FirstName';
import lastname_FIELD from '@salesforce/schema/Contact.LastName';
import email_FIELD from '@salesforce/schema/Contact.Email';
import phone_FIELD from '@salesforce/schema/Contact.Phone';
import {
    getRecord,
    updateRecord,
    generateRecordInputForUpdate,
    getFieldValue,
} from 'lightning/uiRecordApi';
import {
    CurrentPageReference
} from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import dbu_reset_password from '@salesforce/label/c.dbu_reset_password';
import dbu_customer_number from '@salesforce/label/c.Dbu_customer_number';
import dbu_customer_enquiry from '@salesforce/label/c.Dbu_customer_Enquiry';
import dbu_enquire_number from '@salesforce/label/c.Dbu_Enquiry_Number';
import dbu_customer_tm from '@salesforce/label/c.Dbu_customer_tm';
import updateContactRecord from '@salesforce/apex/dbu_CustomerInfoDetailsCtrl.updateContactRecord'; 
export default class Dbu_customerInfo extends LightningElement {
    label = {
        dbu_reset_password,
        dbu_customer_number,
        dbu_customer_enquiry,
        dbu_enquire_number,
        dbu_customer_tm
    };
    //@api recordId;
    userId = Id;
    @track customer;
    @track error;
    @track add1ValBil = 'Test';
    @api recordId;
    @track contactId;
    @track cname;
    @track fname = '';
    @track lname = '';
    @track email = '';
    @track phone = '';
    @track ManagePasswordTxt;
    @track changepasswordtxt;
    @track resetpassword;
    @track phone = '+1 ';
    @track custNumber = '';
    @track showCustomer= true;
    connectedCallback() {

        this.ManagePasswordTxt = ManagePasswordtxt;
        this.changepasswordtxt = Changepasswordtxt;
        this.resetpassword = dbu_reset_password;
    }
    //@wire(fetchCustomerInfoDetails)
    @wire(fetchUserInfoDetails, {
        recId: '$userId'
    })
    wireCustomerDetails({
        error,
        data
    }) {
        console.log('fetchUserInfoDetails>>>>>>32>>', data);
        if (data) {
            //this.isLoading = false;
            console.log('fetchUserInfoDetails>>>>>>36', (data));
            this.customer = JSON.parse(JSON.stringify(data))[0].Contact;
            this.cname = data[0].Contact.dbu_Company_Name__c;
            this.fname=data[0].Contact.FirstName;
            this.lname = data[0].Contact.LastName;
            this.email = data[0].Contact.Email;
            if(data[0].Contact.Account.FSL_ERP_Customer_Code__c != null){
                var country = data[0].Contact.Account.FSL_ERP_Customer_Code__c.split("-");
            }
            if(data[0].Contact.Account.FSL_ERP_Customer_Code__c != null && country[1] === 'USA'){
                this.custNumber = country[0];
            }
            else if(data[0].Contact.Account.Customer_BMS_number__c != null)
              this.custNumber = data[0].Contact.Account.Customer_BMS_number__c;
            console.log('fetchCustomerInfoDetails123>>>>>>388', (this.customer.Phone));
            if(data[0].Contact.Account.FSL_BMS_Instance__c != null && data[0].Contact.Account.FSL_BMS_Instance__c !== 'USA')
                this.showCustomer = false
            if (this.customer.Phone != '' && this.customer.Phone != undefined) {
                let phoneValueData = this.customer.Phone;
                if(phoneValueData.includes("(") ){
                    console.log('coming inside>>>>>>388');

                    this.phone = phoneValueData;
                }
                else 
                {
                    this.formatPhoneNumber(phoneValueData);
                }
            }

            console.log(' this.fname');
            this.error = undefined;
            //console.log('fetchCustomerInfoDetails123>>>>>>19',(data));
            console.log('fetchCustomerInfoDetails123>>>>>>40', (this.customer));
        } else if (error) {
            //this.isLoading = false;
            this.error = error;
            this.customer = undefined;
        }
    }
    handleBillChange(event) {
        console.log('event called')
        if (event.target.name == 'companyname') {
            this.cname = event.target.value;
            console.log('fetchCustomer  cname>>>>>>58', (this.cname));
        }
        if (event.target.name == 'firstname') {
            this.fname = event.target.value;
            console.log('fetchCustomer  fname>>>>>>58', (this.fname));
        }
        if (event.target.name == 'lastname') {
            this.lname = event.target.value;
            console.log('fetchCustomer  lname>>>>>>62', (this.lname));
        }
        if (event.target.name == 'Email') {
            this.email = event.target.value;
            console.log('fetchCustomer Phone>>>>>>66', (this.email));
        }
        if (event.target.name == 'Phone') {
            this.phone = event.target.value;
            console.log('fetchCustomer Phone>>>>>>70', (this.phone));
        }
    }
    updateContact() {
        let record = {
            fields: {
                Id: this.customer.Id,
                dbu_Company_Name__c: this.cname,
                FirstName: this.fname,
                LastName: this.lname,
                Email: this.email,
                Phone: this.phone,
            },
        };
        console.log('fetchCustomer Record>>>>>>83', (record));
        window.console.log('fetchCustomer Record>>>>>>83', (record));
        updateContactRecord({
                recordForUpdate: JSON.stringify(record)
            })
            //updateRecord(record)
            // eslint-disable-next-line no-unused-vars
            .then(() => {
                // Clear the user enter values
                this.record = {};
                console.log('result ===> 74 ' + JSON.stringify(record));
                this.dispatchEvent(
                    // Show success messsage
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record is Updated',
                        variant: 'success',
                    }),
                );
                //return refreshApex(this.contact);
            })
            .catch(error => {
                console.log('error in update' + JSON.stringify(error));
                /* this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Error on data save',
                         message: error.message.body,
                         variant: 'error',
                     }),
                 );*/
            });
    }
    formatPhone(obj) {
        console.log('entering the formatPhone metho??' +obj);
        var numbers = obj.target.value.replace(/\D/g, ''),
            char = {
                0: '+',
                1: ' (',
                4: ') ',
                7: '-'
            };
        obj.target.value = '';
        for (var i = 0; i < numbers.length; i++) {
            obj.target.value += (char[i] || '') + numbers[i];
        }
        console.log('length', obj.target.value)
        if (obj.which == 27){
            if(numbers.length <=3){
                obj.preventDefault();

            }
        }
    }


    formatPhoneNumber(phoneNumberString) {
        console.log('coming hee>>>' +phoneNumberString);
        var cleaned = ('' + phoneNumberString).replace(/\D/g, '')
        console.log('coming he cleanede>>>' +cleaned);

        var match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/)
        console.log('coming he match>>>' +match);

        if (match) {
            console.log('coming hee1111>>>' +'(' + match[1] + ') ' + match[2] + '-' + match[3]);

            this.phone = '+1 (' + match[1] + ') ' + match[2] + '-' + match[3]
        }
    }
      



    /*
     updateAccount() {
         let record = {
             fields: {
                 Id: this.customer.Id,
                 
                 CompanyName: this.cname,
                 FirstName: this.fname,
                 LastName:this.lname ,
                 Email:this.email ,
                 //Phone:this.phone,
             },
         };
         console.log('fetchCustomer Record>>>>>>83',(record));
         window.console.log('fetchCustomer Record>>>>>>83',(record));
         updateRecord(record)
             // eslint-disable-next-line no-unused-vars
             .then(() => {
                 console.log('Inside Then 142 >>> ');
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Success',
                         message: 'Record Is Updated',
                         variant: 'sucess',
                     }),
                 );
                 //return refreshApex(this.contact);
             })
             .catch(error => {
                 this.dispatchEvent(
                     new ShowToastEvent({
                         title: 'Error on data save',
                         //message: error.message.body,
                         variant: 'error',
                     }),
                 );
             });
     }  
     */
}