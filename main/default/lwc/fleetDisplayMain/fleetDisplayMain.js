import { LightningElement, track, api, wire } from 'lwc';
import getFleet from '@salesforce/apex/FleetTriggerHandler.getFleetInformation';

export default class FleetDisplayMain extends LightningElement {
    @track fleetRecords = [];

    @api fleetRec;
    @track imgSrc;
    @track recordId;
    @track showDetails = false;
    fleetResult;

    connectedCallback(){
        this.toggleSpinner();
        getFleet({})
        .then((result) => {
            console.log('get fleet information'+JSON.stringify(result));
            if(result){
                this.fleetRecords = result;
            }
            this.toggleSpinner();
        })
        .catch((error) => {
            console.log('Get Fleet error : '+JSON.stringify(error));
            this.toggleSpinner();
        });
    }

    toggleSpinner(){
        this.showSpinner = (this.showSpinner) ? false : true;
    }

    handlefleetClick(data){
        this.showDetails = false;
        this.recordId = data.detail;
        console.log('data on click -'+data.detail);
    }

}