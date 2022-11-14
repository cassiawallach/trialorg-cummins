import { LightningElement } from 'lwc';
import pubsub from 'c/pubsub' ; 

export default class Dbu_ftrCopyRightInfo extends LightningElement {
 showUS = true;
 showCA;

connectedCallback() {
    this.regiser();
}
regiser(){
    window.console.log('event registered ');
    pubsub.register('locationSelected', this.handleLocationSelected.bind(this));
    
}
handleLocationSelected(location) {
    if(location == 'US'){
        this.showUS = true;
        this.showCA = false;

    } if(location == 'CA'){
        this.showUS = false;
        this.showCA = true;
    }
}

}