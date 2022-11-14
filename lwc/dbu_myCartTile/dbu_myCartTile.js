import { LightningElement, api, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import pubsub from 'c/pubsub';



export default class Dbu_myCartTile extends LightningElement {
   
   @track sldsExpended = false;
   @track selectedText='Cart';
   @track selectedData='US';
   @track showHideDropDown = false;
   @api cartitem;
   @api cartsize;

   message;
   connectedCallback() {
      this.regiser();
   }
   regiser() {
      window.console.log('event registered ');
      pubsub.register('addedtocart', this.handleAddToCartClickEvent.bind(this));
      pubsub.register('cartCount', this.handleCartCountEvent.bind(this));
   }

   handleCartClick() {
      console.log('## 1 Cart clicked');
      this[NavigationMixin.Navigate]({
         "type": "standard__component",
         "attributes": {
            "componentName": "dbuCartContainer"
         }
      });
   }

   handleAddToCartClickEvent(messageFromEvt) {
      window.console.log('event handled ', messageFromEvt);
      this.message = messageFromEvt 
                     ? JSON.stringify(messageFromEvt, null, '\t') 
                     : 'no message payload';
      this.cartsize = parseInt(this.cartsize) + 1;
   }

   handleCartCountEvent(messageFromEvt) {
      window.console.log('### event handled cart count ', messageFromEvt);
      window.console.log('### message ', JSON.stringify(messageFromEvt) );
      this.message = messageFromEvt 
                     ? JSON.stringify(messageFromEvt, null, '\t') 
                     : 'no message payload';
      this.cartsize = messageFromEvt 
                        ? JSON.stringify(messageFromEvt.message, null, '\t') 
                        : 'no message payload';
   }

   get ldsDiv()
     {
        return this.sldsExpended ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
     }
     get languageSelector()
     {
        return this.sldsExpended ? 'languageSelectorOpen' : 'languageSelectorClosed';
     }
    ldsClickHandler()
    {
        if(this.sldsExpended)
            {
                this.sldsExpended = false;
            }
            else{
                this.sldsExpended = true;
            }
    }
    
    onmouseoutHandler()
    {
        this.sldsExpended = false;
    }
    
    handleButtonselect (event){
        console.log('entering the method>>>');
        console.log(event.detail.value);
        let selectedValue = event.detail.value;
        let selectedObject  = this.optionsList.find(function(element){
                    return element.value === selectedValue;
        });
        const test = selectedObject.label;
        this.dispalyLabel  = test;
        //this.iconName =  selectedObject.iconName;
        console.log('selected dispalyLabel ->' + this.dispalyLabel);
        console.log('selected Label ->' + test);
       // console.log('selected iconName ->' + selectedObject.iconName);
    }

}