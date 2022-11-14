import { LightningElement, track, api, wire } from 'lwc';
import fetchNarrative from '@salesforce/apex/EVL_CL_NarrativeController.fetchNarrative';
import narrativesDown from '@salesforce/label/c.FSL_ClaimNarrativesDown'
export default class EVL_Narratives extends LightningElement {
    @track loadingSpinner = true;
    @track narrativeList = [];
    @api claimnumber = '';
    @track noDataFound = false;
    @track msg = '';

    label = {
         narrativesDown
    }

    connectedCallback() {
        console.log('claimnumber',this.claimnumber);
        this.getNarrativeList();
    }
    
    getNarrativeList () {
        this.narrativeList = [];
        this.noDataFound = false;
        this.loadingSpinner = true;
        // console.log('claimnumber from lwc $%',claimnumber);
        console.log('from getNarrativeList method');
        fetchNarrative({claimNumber: this.claimnumber})
        .then(result => {
            if(result.length > 0){
                console.log('narrative response--'+result);
                this.loadingSpinner = false;

                let r = result[0].DataArea;

                if(result[0].DataArea.Header != undefined){
                    r = result[0].DataArea.Header.Notes;
                }
                console.log('$$ result:'+ r);
                for(let i = 0; i < r.length; i++ ) {
                    this.narrativeList = [...this.narrativeList, {Note: r[i].Note, NoteType: r[i].NoteType}];
                    this.noDataFound = false;
                }
                //if the result had no notes to add, get the message
                if(this.narrativeList.length == 0) {
                    this.msg = result[0].header.message;
                    this.noDataFound = true;
                } else {
                    this.msg = '';
                    this.noDataFound = true;
                }
            } else {
                this.loadingSpinner = false;
                this.noDataFound = true;
                this.msg = narrativesDown;
            }

            // this.narrativeList = result;
            console.log('r: '  + r[0].Note);
            console.log('narrativeList: '  + this.NarrativeList);
        })
        .catch(error => {
            console.log(error);
        });
    }
}