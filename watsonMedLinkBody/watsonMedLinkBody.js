import { LightningElement } from 'lwc';
import watsonXAssistantMedLinkAssets from '@salesforce/resourceUrl/watsonXAssistantMedLinkAssets';

export default class WatsonMedLinkBody extends LightningElement {
    mapMarkers = [
        {
            location: {
                City: 'San Francisco',
                Country: 'USA',
                PostalCode: '94105',
                State: 'CA',
                Street: 'The Landmark @ One Market, Suite 300',
            },
            value: 'location001',
            title: 'The Landmark Building',
            description:
                'The Landmark is considered to be one of the city&#39;s most architecturally distinct and historic properties', //escape the apostrophe in the string using &#39;
            icon: 'standard:account',
        },
    ];
    reschedule = watsonXAssistantMedLinkAssets + '/reschedule.jpg'
    bookApp = watsonXAssistantMedLinkAssets + '/book_appointment.jpg'
    liveAgent = watsonXAssistantMedLinkAssets + '/livesupport.png'
    emailAlert = watsonXAssistantMedLinkAssets + '/email.png'
    caneclApp =  watsonXAssistantMedLinkAssets + '/cancel_app.jpeg'
    airemedy = watsonXAssistantMedLinkAssets + '/Airem.png'
}