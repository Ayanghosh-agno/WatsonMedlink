import { LightningElement } from 'lwc';
import watsonXAssistantMedLink from '@salesforce/resourceUrl/watsonXAssistantMedLink';
import { loadScript } from 'lightning/platformResourceLoader';
export default class WatsonMedLinkFooter extends LightningElement {
    connectedCallback() {
        loadScript(this, watsonXAssistantMedLink).then(() => { });
    }
}