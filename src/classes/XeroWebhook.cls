/**
* @author Ben Edwards (ben@edwards.nz)
* @date 25th May 2022
* @description Process receiving webhooks from Xero
**/
@RestResource (urlMapping='/xero/webhook')
global without sharing class XeroWebhook {

    @HttpPost
    global static void processXeroWebhook () {

        // The request that has come throguh to the endpoint
        RestRequest request = RestContext.request;

        // Instantiate a new response to return to the API
        RestResponse response = RestContext.response != null ? RestContext.response : new RestResponse();

        // If we are running the Xero validation process, run that method
        if (Xero_Settings__c.getInstance().Intent_to_Receive__c) {

            processIntentToReceive(request, response);
            return;
        }
        // Else, process a proper Xero webhook for Contact or Invoice
        else {

            processRecordChange(request, response);
        }

    }

    /**
    *   @description Process the Xero record update process
    **/
    global static void processRecordChange (RestRequest request, RestResponse response) {

        // Load the response from Xero
        WebhookMessage webhookMessage = (WebhookMessage) JSON.deserialize(request.requestBody.toString(), WebhookMessage.class);

        // Iterate over the events in the webhook to get the Xero Tenant IDs
        for (WebhookEvent webhookEvent :webhookMessage.events) {

            // Do something with event here
        }

        response.statusCode = 200;
    }


    /**
    *   @description This method is used to process the ITR from Xero. It's used as a one-off
                     to verify that the webhook is secure
    **/
    global static void processIntentToReceive (RestRequest request, RestResponse response) {

        // Retrieve the Xero signature
        String xeroSignature = request.headers.get('x-xero-signature');

        // Retrieve the Xero payload
        String xeroPayload = request.requestBody.toString();

        // We need to validate that the Xero Payload is hashed using HMACSHA256 and the provided key, and base64 encoded, 
        // it should match the signature above

        // Verify the signature
        Blob signedPayload = Crypto.generateMac('hmacSHA256', Blob.valueOf(xeroPayload), Blob.valueOf(Xero_Settings__c.getInstance().Webhook_Key__c));

        String encodedPayload = EncodingUtil.base64Encode(signedPayload);

        // Return status code based on whether signed payload matches or not
        response.statusCode = encodedPayload == xeroSignature ? 200 : 401;
    }


    public class WebhookMessage {
        public List<WebhookEvent> events;
        public Integer firstEventSequence;
        public Integer lastEventSequence;
        public String entropy;
    }

    public class WebhookEvent {
        public String resourceUrl;
        public String resourceId;
        public String tenantId;
        public String tenantType;
        public String eventCategory; 
        public String eventType;
        public String eventDateUtc;
    }
}