import { LightningElement,api,track } from 'lwc';
import SelectItems from '@salesforce/label/c.dbu_SelectItemsOnReturn';
import ReturnMethod from '@salesforce/label/c.dbu_ReturnMethod';
import ReviewReturn from '@salesforce/label/c.dbu_ReviewReturn';
import returnInitiated from '@salesforce/label/c.dbu_ReturnInitiatedOnHeader';
import step_SelectItems from '@salesforce/label/c.dbu_SelectItems';
import active from '@salesforce/label/c.dbu_activeOnReturn';
import step_ReturnMethod from '@salesforce/label/c.dbu_ReturnMethodOnHeader';
import completed from '@salesforce/label/c.dbu_completedOnReturn';
import step_ReviewReturn from '@salesforce/label/c.dbu_ReviewReturnOnReturnHeader';
import step_ReturnInitiated from '@salesforce/label/c.dbu_ReturnInitiatedStatus';


export default class Dbu_headerReturnSteps extends LightningElement {
    @api step;
    @track _selectItemsClassName;
    @track _returnClassName;
    @track _reviewClassName;
    @track _initiatedClassName;
    @track selectItems = SelectItems;
    @track returnMethod = ReturnMethod;
    @track reviewReturn = ReviewReturn;
    @track returnInitiated = returnInitiated;
    @track step_SelectItems = step_SelectItems;
    @track active = active;
    @track step_ReturnMethod = step_ReturnMethod;
    @track completed = completed;
    @track step_ReviewReturn = step_ReviewReturn;
    @track step_ReturnInitiated = step_ReturnInitiated;

    get selectItemsClassName()
    {
        console.log('this.step=>'+this.step);
        if(this.step == this.step_SelectItems)
        {
            this._selectItemsClassName = this.active;
            this._returnClassName = '';
            this._reviewClassName = '';
            this._initiatedClassName = '';
        }
        if(this.step == this.step_ReturnMethod)
        {
            this._selectItemsClassName = this.completed;
            this._returnClassName = this.active;
            this._reviewClassName = '';
            this._initiatedClassName = '';
        }
        if(this.step == this.step_ReviewReturn)
        {
            this._selectItemsClassName = this.completed;
            this._returnClassName = this.completed;
            this._reviewClassName = this.active;
            this._initiatedClassName = '';
        }
        if(this.step == this.step_ReturnInitiated)
        {
            this._reviewClassName = this.completed;
            this._selectItemsClassName = this.completed;
            this._returnClassName = this.completed;
            this._initiatedClassName = this.completed;
        }

        return this._selectItemsClassName ;
    }
    
}