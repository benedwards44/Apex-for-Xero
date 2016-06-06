# Apex-for-Xero

This application contains Apex utilities for accessing the [Xero](http://developer.xero.com) REST APIs.

These classes are set up to use the [Private Application](http://developer.xero.com/documentation/getting-started/private-applications/) type.

The aim of this project is to act as a starting point for accessing Xero APIs via Apex. I wanted to share this project as I spent a lot of time getting the authentication working for Xero, as Apex doesn't have a standard OAuth 1.0 library and there wasn't much detail online about it.

For more information about the Xero APIs, check out:
http://developer.xero.com/documentation/api/api-overview/

## Quick Setup

1. Create your private and public keys
	- Setup -> Security Controls -> Certification and Key Management
	- Create a Self-Signed Certification. Give it the name of XeroCertificate
	- Click Download Certificate. This is the certificate you upload into Xero.
2. [Create your application](http://developer.xero.com/documentation/getting-started/getting-started-guide/) in Xero and upload your public key .cer file generated above 
3. Deploy this package to a Salesforce environment ([Deploy to Org](https://githubsfdeploy.herokuapp.com/app/githubdeploy/benedwards44/Apex-for-Xero))
4. Access the Xero Settings tab and create a new Xero Settings record. Enter your Xero credentials (from your application created in Xero)
5. You can now access Xero API resources via Apex. Eg... `XeroAccountingApi.getContacts();`

## Usage

Once the above steps are complete, you can now access the example methods to access the Xero API resources. There are currently only a few pre-built methods set up to start using. Please use these as a base and extend as necessary.

#### Get Contacts

This method queries all contacts in your Xero org. To execute, simply run:
```
XeroAccountingApi.getContacts();
```
And a list of type XeroContact is returned.

#### Create Contact

This method creates a contact for the given XML:
```
// Create a Contact
XeroContact newContact = new XeroContact();
newContact.Name = 'ABC Limited 1';

// Send Contact to Xero
XeroAccountingApi.createContact(XeroXmlUtility.serialize(newContact, 'Contact'));
```
You can view example XML requests [here](http://developer.xero.com/documentation/api/contacts/)

#### Get Invoices

This method queries all invoices in your Xero org. To execute, run:
```
XeroAccountingApi.getInvoices();
```

#### Create Invoice

This method creates an invoice for the given XML:
```
XeroInvoice newInvoice = new XeroInvoice();
newInvoice.Date_x = system.today();
... // Add additional Invoice details based on the XeroInvoice wrapper

// Send Invoice to Xero
XeroAccountingApi.createInvoice(XeroXmlUtility.serialize(newInvoice, 'Invoice'));
```
You can view example XML requests [here](http://developer.xero.com/documentation/api/invoices/)


## Contributing

Feel free to fork this repo and use as you wish. I'd welcome anyone to add additional methods and add to this project, I will do the same as I go.
