# Apex-for-Xero

<a href="https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

(deploy from Github from https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero)

This application contains Apex utilities for accessing the [Xero](http://developer.xero.com) REST APIs.

These classes are set up to use the [Private Application](http://developer.xero.com/documentation/getting-started/private-applications/) type.

The aim of this project is to act as a starting point for accessing Xero APIs via Apex. I wanted to share this project as I spent a lot of time getting the authentication working for Xero, as Apex doesn't have a standard OAuth 1.0 library and there wasn't much detail online about it.

For more information about the Xero APIs, check out:
http://developer.xero.com/documentation/api/api-overview/

## Quick Setup

1. Create an Auth. Provider within your Salesforce Org:
    1. Setup -> Security Controls -> Auth. Providers -> New
    2. Provider Type = "Open ID Connect"
    3. Name = "Xero"
    4. Consumer Key = "ABC" (this is temporary, we will update this with the Xero Consumer Key once we have it)
    5. Consumer Secret = "ABC" (as above)
    7. Authorize Endpoint URL = "https://login.xero.com/identity/connect/authorize"
    8. Token Endpoint URL = "https://login.xero.com/identity/connect/token"
    9. Default Scopes: "openid profile email offline_access accounting.transactions accounting.contacts" (you can see all scopes here https://developer.xero.com/documentation/oauth2/scopes)
    
    Leave everything as is. Click save and then copy the generated "Callback URL". Eg. https://login.salesforce.com/services/authcallback/00D2v000003QVUrCAO/Xero

2. Create the Xero App:
    1. https://app.xero.com/ -> My Apps -> New app
    2. App name = Your unique name
    3. Company or application URL = Can be anything, suggest either your Salesforce Org URL or your company website
    4. OAuth 2.0 redirect URI = Paste in the "Callback URL" copied from step 1 above

3. Create the Salesforce Named Credential:
    1. Setup -> Named Credential -> New Named Credential
    2. Label = "Xero"
    3. Name = "Xero"
    4. URL = "https://api.xero.com/api.xro/2.0"
    5. Identity Type = "Named Principal"
    6. Authentication Protocol = "OAuth 2.0"
    7. Authentication Provider = "Xero" (the provider created in step 1)
    8. Start Authentication Flow on Save = Checked (this will trigger the OAuth process to Xero)

4. Deploy this package to a Salesforce environment ([Deploy to Org](https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero))
5. You now need to retrieve the Xero Tenant ID and store in the Custom Label:
    1. Run the Apex method `XeroAPI.getXeroTenantId();`
    2. Copy the returned value
    3. Update to the label:
        Setup -> Create -> Custom Labels -> Xero_Tenant_Id -> Edit -> Paste in value from above
6. You can now access Xero API resources via Apex. Eg... `XeroAPI.getContacts();`

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

XeroContact newContact = new XeroContact();
myContact.EmailAddress = 'Snoop@Dogg.com';
... // Add additional Invoice details based on the XeroContact wrapper

XeroAPI.sendContact(newContact);
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
newInvoice.Date_x = system.today();
... // Add additional Invoice details based on the XeroInvoice wrapper

// Send Invoice to Xero
XeroAPI.sendInvoice(newInvoice);
```
You can view example JSON requests [here](http://developer.xero.com/documentation/api/invoices/)


## Contributing

Feel free to fork this repo and use as you wish. I'd welcome anyone to add additional methods and add to this project, I will do the same as I go.
