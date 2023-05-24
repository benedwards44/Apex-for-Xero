/**
* @author Ben Edwards (ben@edwards.nz)
* @date 25th May 2022
* @description Test class for Xero webhook
**/
@isTest 
public class XeroWebhookTest {

    @TestSetup
    static void makeData(){
        
        // Create the Xero settings
        insert new Xero_Settings__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            Intent_to_Receive__c = false,
            Webhook_Key__c = 'ABC123'
        );
    }

    @isTest
    static void testIntentToReceive() {

        // Check the Intent to Receive checkbox on the Custom Setting
        Xero_Settings__c xeroSettings = Xero_Settings__c.getOrgDefaults();
        xeroSettings.Intent_to_Receive__c = true;
        update xeroSettings;

        RestContext.request = new RestRequest();
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestURI = '/xero/webhook';
        RestContext.request.headers.put('x-xero-signature', 'Fake signature');
        RestContext.request.requestBody = Blob.valueOf('{}');

        Test.startTest();

        XeroWebhook.processXeroWebhook();

        Test.stopTest();
    }

    @isTest
    static void testProcessRecordChange() {

        XeroWebhook.WebhookEvent testWebhookEvent = new XeroWebhook.WebhookEvent();
        testWebhookEvent.resourceId = 'ABC123';

        XeroWebhook.WebhookMessage testWebhookMessage = new XeroWebhook.WebhookMessage();
        testWebhookMessage.events = new List<XeroWebhook.WebhookEvent>{testWebhookEvent};

        RestContext.request = new RestRequest();
        RestContext.request.httpMethod = 'POST';
        RestContext.request.requestURI = '/xero/webhook';
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(testWebhookMessage));

        Test.startTest();

        XeroWebhook.processXeroWebhook();

        Test.stopTest();

        // Asset expected result for webhook processes
    }
}