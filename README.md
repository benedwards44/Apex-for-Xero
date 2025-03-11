# Apex-for-Xero

<a href="https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

(deploy from Github from https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero)

This application contains Apex utilities for accessing the [Xero](http://developer.xero.com) REST APIs.

The aim of this project is to act as a starting point for accessing Xero APIs via Apex. I wanted to share this project as I spent a lot of time getting the authentication working for Xero, as Apex doesn't have a standard OAuth 1.0 library and there wasn't much detail online about it. Having said that, Xero has now migrated to OAuth 2.0 so it's a bit easier however there is still some setup involved. Once the authentication is done the rest of the API is relatively straight forward.

For more information about the Xero APIs, check out:
http://developer.xero.com/documentation/api/api-overview/

## Quick Setup

1. Create an Auth. Provider within your Salesforce Org:
    1. Setup -> Security Controls -> Auth. Providers -> New
    2. Provider Type = `Open ID Connect`
    3. Name = `Xero`
    4. Consumer Key = `ABC` (this is temporary, we will update this with the Xero Consumer Key once we have it)
    5. Consumer Secret = `ABC` (as above)
    7. Authorize Endpoint URL = `https://login.xero.com/identity/connect/authorize`
    8. Token Endpoint URL = `https://identity.xero.com/connect/token`
    9. User Info Endpoint URL = `https://identity.xero.com/connect/userinfo`
    10. Token Issuer = `https://identity.xero.com`
    9. Default Scopes: `openid profile email offline_access accounting.transactions accounting.contacts` (you can see all scopes here https://developer.xero.com/documentation/oauth2/scopes)
    
    Leave everything as is. Click save and then copy the generated "Callback URL". Eg. https://login.salesforce.com/services/authcallback/00D2v000003QVUrCAO/Xero

2. Create the Xero App:
    1. https://developer.xero.com -> My Apps -> New app
    2. App name = Your unique name
    3. Company or application URL = Can be anything, suggest either your Salesforce Org URL or your company website
    4. OAuth 2.0 redirect URI = Paste in the "Callback URL" copied from step 1 above
    5. Take the generated Client Id and Client Secret and paste into the Auth. Provider created above

3. Create the Salesforce Named Credential:
    1. Setup -> Named Credential -> New Named Credential
    2. Label = `Xero`
    3. Name = `Xero`
    4. URL = `https://api.xero.com`
    5. Identity Type = `Named Principal`
    6. Authentication Protocol = `OAuth 2.0`
    7. Authentication Provider = `Xero` (the provider created in step 1)
    8. Start Authentication Flow on Save = Checked (this will trigger the OAuth process to Xero)

4. Deploy this package to a Salesforce environment ([Deploy to Org](https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero))
5. You now need to retrieve the Xero Tenant ID and store in the Custom Label:
    1. Run the Apex method `XeroAPI.getXeroTenantId();`
    2. Copy the returned value
    3. Update to the label:
        Setup -> Create -> Custom Labels -> Xero_Tenant_Id -> Edit -> Paste in value from above
6. You can now access Xero API resources via Apex. Eg... `XeroAPI.getContacts();`

Note: If you want to connect to multiple Xero Orgs, you would need to create a more scalable solution for this, such as a Custom Object or Custom Setting/Metadata to track the various Xero connections.

## Webhooks

In order to use Xero Webhooks, some additional setup is required:

1. First, you need to create a public URL for Xero to send webhooks to. To do this:
    1. Setup -> Develop -> Sites -> New (Note: you could use an existing Site if you prefer)
    2. Give the Site a name. Could be "API" or "Webhooks" or what is preferred. 
    3. Give the site a URL suffix (eg. "api")
    4. For Active Site Homepage, select InMaintance or you could create a landing page. This isn't actually needed for this scenario
    5. Click Save, then Public Access Settings
    6. Under Enabled Apex Classes, select XeroWebhook and save.
2. Now, you need to enable Xero Webhooks in Xero. Following the instructions here: https://developer.xero.com/documentation/guides/webhooks/creating-webhooks/
    1.  For the Notifications URL, enter the domain and URL created above and also include `/services/apexrest/xero/webhook` which is the endpoint for the Apex Class XeroWebhook. For example `https://mydomain.my.salesforce-sites.com/api/services/apexrest/xero/webhook`. You can test the URL by navigating to it, you should receive a "HTTP Method 'GET' not allowed. Allowed are POST" error, which at least means the URL is correct
    2. Click Save and copy the "Webhook Key"
    3. Paste this key into the Xero Settings custom setting.
3. Lastly, you need to activate the "Intent to Receive". This is a security measure which tells Xero the webhooks are signed and going to the right place. 
    1. Setup -> Develop -> Custom Settings -> Xero Settings -> Manage
    2. Check "Intent to Receive" and click save
    3. Click "Send Intent to Recieve" on the Xero side. This will send a few messages to Salesforce and Salesforce will validate these are received and Xero will validate they're processed correctly. Once Xero returns "OK", go back to Salesforce and uncheck "Intent to Receive".
4. Webhooks should now be sending! You will need to update the `XeroWebhook.processRecordChange()` with your logic to process webhooks how you like.

## Usage

Once the above steps are complete, you can now access the example methods to access the Xero API resources. There are currently only a few pre-built methods set up to start using. Please use these as a base and extend as necessary.

#### Get Contacts

This method queries all contacts in your Xero org. To execute, simply run:
```
XeroAPI.getContacts();
```
And a list of type XeroContact is returned.

#### Create Contact

```
// Send Contact to Xero
Account myAccount = [SELECT Name, ... FROM Account];
XeroAPI.sendAccount(myAccount);
```
You can view example JSON requests [here](http://developer.xero.com/documentation/api/contacts/)

#### Get Invoices

This method queries all invoices in your Xero org. To execute, run:
```
XeroAPI.getInvoices();
```

#### Create Invoice

This method creates an invoice for the given XML:
```
XeroInvoice newInvoice = new XeroInvoice();
newInvoice.Date_x = String.valueOf(System.today());
... // Add additional Invoice details based on the XeroInvoice wrapper

// Send Invoice to Xero
XeroAPI.sendInvoice(XeroXmlUtility.serialize(newInvoice, 'Invoice'));
```
You can view example JSON requests [here](http://developer.xero.com/documentation/api/invoices/)


## Contributing

Feel free to fork this repo and use as you wish. I'd welcome anyone to add additional methods and add to this project, I will do the same as I go.
