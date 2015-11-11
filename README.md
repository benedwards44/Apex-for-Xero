# Apex-for-Xero

This application contains Apex utilities for accessing the Xero APIs.

These classes currently support only the Private Application type. For more information about the Xero APIs, get out:
http://developer.xero.com/documentation/api/api-overview/

## Quick Setup

1 - Create your private and public keys. Apex only supports PKCS#8 format, not PKCS#12 with the Xero docs recommend. Use these commands to generate your private key in PKCS#8 format
    openssl genrsa -out xero_privatekey.pem 1024
    openssl req -newkey rsa:1024 -x509 -key xero_privatekey.pem -out xero_publickey.cer -days 1825 
    openssl pkcs8 -topk8 -nocrypt -in xero_privatekey.pem -out xero_privatekey.pcks8
2 - Create your application in Xero and upload your public key .cer file generated above (http://developer.xero.com/documentation/getting-started/getting-started-guide/)
3 - Deploy the /src/ folder to your Salesforce Org
4 - Access the Xero Settings tab and create a new Xero Settings record. Enter your Xero credentials.
5 - You can now access Xero API resources via Apex. Eg...
