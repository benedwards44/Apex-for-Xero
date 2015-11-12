# Apex-for-Xero

This application contains Apex utilities for accessing the [Xero](http://developer.xero.com) REST APIs.

These classes are set up to use the [Private Application](http://developer.xero.com/documentation/getting-started/private-applications/) type.

The aim of this project is to act as a starting point for accessing Xero APIs via Apex. I wanted to share this project as I spent a lot of time getting the authentication working for Xero, as Apex doesn't have a standard OAuth 1.0 library and there wasn't much detail online about it.

For more information about the Xero APIs, check out:
http://developer.xero.com/documentation/api/api-overview/

## Quick Setup

1. Create your private and public keys. Apex only supports PKCS#8 format, not PKCS#12 which the Xero docs recommend. Use these commands to generate your private key in PKCS#8 format
```
openssl genrsa -out xero_privatekey.pem 1024
openssl req -newkey rsa:1024 -x509 -key xero_privatekey.pem -out xero_publickey.cer -days 1825 
openssl pkcs8 -topk8 -nocrypt -in xero_privatekey.pem -out xero_privatekey.pcks8
```
2. [Create your application](http://developer.xero.com/documentation/getting-started/getting-started-guide/) in Xero and upload your public key .cer file generated above 
3. Deploy the /src/ folder to your Salesforce Org
4. Access the Xero Settings tab and create a new Xero Settings record. Enter your Xero credentials (from your application created in Xero)
5. You can now access Xero API resources via Apex. Eg... `XeroAccountingApi.getContacts();`

## Usage

Once the above steps are complete, you can now access the example methods to access the Xero API resources. There is currently one simple getContacts() method setup.

#### Get Contacts

This method queries all contacts in your Xero org. To execute, simply run:
```
XeroAccountingApi.getContacts();
```
And a list of type XeroContact is returned.

## Contributing

Feel free to fork this repo and use as you wish. I'd welcome anyone to add additional methods and add to this project, I will do the same as I go.
