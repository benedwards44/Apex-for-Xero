/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {

    // Ordering ENUM
    public enum SortOrder {ASCENDING, DESCENDING}

    
    public static List<XeroAccount> parseAccounts(String jsonBody) {

        // Re-serialize just the Accounts portion back to JSON
        String jsonSerialized = generateJsonStringForParsing (jsonBody, 'Accounts');
        
        // And finally parse the now re-serialized contact list back into Account objects
        return (List<XeroAccount>) JSON.deserialize(jsonSerialized, List<XeroAccount>.class);
    }
    
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
    *   @description Method to return ALL contacts for your Xero environment
    *   @return List of Xero Contact wrapper classes
    **/
    public static XeroContact getContact (String xeroContactId) {

        XeroContact xeroContact = new XeroContact();

        // Execute the callout to the Contacts resource
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts/' + xeroContactId, null);

        // If successful response
        if (response.getStatusCode() == 200) {

            // Use the parser to convert the response into Xero objects
            xeroContact = XeroCalloutResponseParser.parseContacts(response.getBody())[0];
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroContact;
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
        HttpResponse response = XeroCalloutUtility.executeCallout('POST', 'Contacts', contactBody);

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
    *   @description Method to return ALL invoices for your Xero environment
    *   @return List of Xero Invoice wrapper classes
    **/
    public static List<XeroInvoice> getInvoices () {

        return getInvoices(null, null);
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to return ALL invoices for your Xero environment
    *   @return List of Xero Invoice wrapper classes
    **/
    public static List<XeroInvoice> getInvoices (String orderBy, XeroAccountingApi.SortOrder sortOrder) {

        List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

        String endpoint = 'Invoices';

        // Add any ordering parameters
        if (String.isNotBlank(orderBy)) {

            endpoint += '?order=' + orderBy;
        }

        // Set a sort order if exists
        // Only bothering with descending, as ascending is done by default
        if (sortOrder != null && sortOrder == XeroAccountingApi.SortOrder.DESCENDING) {

            endpoint += '%20DESC';
        }

        // Execute the callout to the Invoice resource
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', endpoint, null);

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
    *   @description Method to return a single invoice for your Xero environment for a given Xero Invoice
    *   @return Single Xero Invoice
    **/
    public static XeroInvoice getInvoice (String invoiceId) {

        XeroInvoice xeroInvoice = new XeroInvoice();

        // Execute the callout to the Invoice resource
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices/' + invoiceId, null);

        // If successful response
        if (response.getStatusCode() == 200) {

            // Use the parser to convert the response into Xero objects
            xeroInvoice = XeroCalloutResponseParser.parseInvoices(response.getBody())[0];
        }
        else {

            // Raise error
            throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
        }

        return xeroInvoice;
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to return all invoices for a given Contact Id
    *   @return List of Xero Invoice wrapper classes
    **/
    public static List<XeroInvoice> getInvoicesForContact (String xeroContactId) {

        List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

        // Execute the callout to the Invoice resource with the Contact ID filter
        HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Invoices?where=Contact.ContactID%20%3D%20Guid%28%22' + xeroContactId + '%22%29', null);

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
        HttpResponse response = XeroCalloutUtility.executeCallout('POST', 'Invoices', invoiceBody);

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
