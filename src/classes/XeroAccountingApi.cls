/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to return ALL contacts for your Xero environment
    *   @return List of Xero Contact wrapper classes
    **/
    public static List<XeroContact> getContacts () {

        List<XeroContact> xeroContacts = new List<XeroContact>();

        // Execute the callout to the Contacts resource
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts', null);

        // If successful response
        if (response.getStatusCode() == 200) {

        	// Use the parser to convert the response into Xero objects
            xeroContacts = XeroCalloutResponseParser.parseContacts(response.getBody());
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroContacts;
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to create a Contact in Xero. 
    *   @return Returns the Contact Id of the Contact created in Xero
    **/
    public static XeroContact createContact (String contactBody) {

        // The created contact to return
        XeroContact createdContact;

        // Execute the callout to the Contacts resource
        HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Contacts', contactBody);

        // If successful response
        if (response.getStatusCode() == 200) {

        	// Use the parser to convert the response into Xero objects
            createdContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return createdContact;
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to return ALL contacts for your Xero environment
    *   @return List of Xero Contact wrapper classes
    **/
    public static List<XeroInvoice> getInvoices () {

        List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

        // Execute the callout to the Contacts resource
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices', null);

        // If successful response
        if (response.getStatusCode() == 200) {

        	// Use the parser to convert the response into Xero objects
            xeroInvoices = XeroCalloutResponseParser.parseInvoices(response.getBody());
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroInvoices;
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to create an invoice in Xero. 
    *   @return Returns the invoice Id of the invoice created in Xero
    **/
    public static XeroInvoice createInvoice (String invoiceBody) {

    	// The created invoice to return
        XeroInvoice createdInvoice;

        // Execute the callout to the Contacts GET resource
        HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Invoices', invoiceBody);

        // If successful response
        if (response.getStatusCode() == 200) {

        	// Use the parser to convert the response into Xero objects
            createdInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }
        return createdInvoice;
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Custom exception class to throw errors for web service callouts
    **/
    public class XeroAccountingApiException extends Exception {}

}