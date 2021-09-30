import { LightningElement, api, track } from 'lwc';
import fleetRecs from '@salesforce/resourceUrl/Fleet_Images';

export default class FleetRecordCard extends LightningElement {
    @api fleetRec;
    @track imgSrc;
    recordId;

    connectedCallback(){
        if(this.fleetRec)
        {
            this.imgSrc = fleetRecs+'/Images/'+this.fleetRec.Image_URL__c;
        }  
    }
    handleFleetClick(event){
        console.log('on roq click-- '+this.fleetRec.Id);
        this.recordId = this.fleetRec.Id;
        const selectedEvent = new CustomEvent("fleetclick", {
            detail: this.recordId
          });
          // Dispatches the event.
          this.dispatchEvent(selectedEvent);
    }
}