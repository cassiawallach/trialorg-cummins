import { LightningElement,wire,track } from 'lwc';
import getUserDetails from '@salesforce/apex/dbu_currentLoggedInUser.getUserDetails';
import Id from '@salesforce/user/Id';
import dbu_current_loggedin_username from "@salesforce/label/c.dbu_current_loggedin_username";


export default class Dbo_currentLoggedInUser extends LightningElement {
    userId = Id;
    @track user;
    @track error;

    label = {
        dbu_current_loggedin_username    
    }

    @wire(getUserDetails, {
        recId: '$userId'
    })
    wiredUser({
        error,
        data
    }) {
        if (data) {
            this.user = data;

        } else if (error) {

            this.error = error;
        }
    }
}