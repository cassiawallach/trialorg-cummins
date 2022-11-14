import { LightningElement,wire,track } from 'lwc';
import getUserDetails from '@salesforce/apex/dbu_currentLoggedInUser.getUserDetails';
import Id from '@salesforce/user/Id';

export default class Dbu_myCurrentUser extends LightningElement {
    userId = Id;
    @track user;
    @track error;
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