import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createLead from '@salesforce/apex/LeadController.createLead'; // Import the Apex method

export default class CreateLeadForm extends LightningElement {
    @track firstName = '';
    @track lastName = '';
    @track email = '';
    @track company = '';
    @track leadSource = '';

    leadSourceOptions = [ // Example Lead Source Picklist Options -  Ideally fetch from Salesforce metadata in real app
        { label: 'Web', value: 'Web' },
        { label: 'Referral', value: 'Referral' },
        { label: 'Partner', value: 'Partner' },
        { label: 'Other', value: 'Other' }
    ];

    handleFirstNameChange(event) {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event) {
        this.lastName = event.target.value;
    }

    handleEmailChange(event) {
        this.email = event.target.value;
    }

    handleCompanyChange(event) {
        this.company = event.target.value;
    }

    handleLeadSourceChange(event) {
        this.leadSource = event.target.value;
    }

    handleCreateLead() {
        const { firstName, lastName, email, company, leadSource } = this; // Destructure properties

        createLead({ firstName: firstName, lastName: lastName, email: email, company: company, leadSource: leadSource })
            .then(leadId => {
                // Handle successful Lead creation
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Lead created successfully with ID: ' + leadId,
                        variant: 'success'
                    })
                );
                // Optionally, navigate to the newly created Lead record page.
                // Example (requires NavigationMixin - import { NavigationMixin } from 'lightning/navigation'; and extend class with NavigationMixin):
                /*
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: leadId,
                        actionName: 'view'
                    }
                });
                */
                // Reset form fields after successful creation (optional)
                this.firstName = '';
                this.lastName = '';
                this.email = '';
                this.company = '';
                this.leadSource = '';
            })
            .catch(error => {
                // Handle error from Apex method (including AuraHandledException from LeadController)
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating lead',
                        message: error.body.message, // Error message from AuraHandledException in Apex
                        variant: 'error'
                    })
                );
                // Log error for debugging purposes (optional)
                console.error('Error creating lead: ', error);
            });
    }
}