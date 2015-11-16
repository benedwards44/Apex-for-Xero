/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Class to parse responses from Xero callouts
**/
public with sharing class XeroCalloutResponseParser {
	
	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to convert JSON responses into Xero objects
    *   @return Returns a Xero wrapper class object from a given response body
    **/
    public static List<XeroContact> parseContacts(String jsonBody) {

    	// Parse the JSON response
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = JSON.serialize((List<Object>) jsonResponseMap.get('Contacts'));

        // And finally parse the now re-serialized contact list back into Contact objects
        return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
    }


    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Method to convert JSON responses into Xero objects
    *   @return Returns a Xero wrapper class object from a given response body
    **/
    public static List<XeroInvoice> parseInvoices(String jsonBody) {

        // Parse the JSON response
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonBody);

        // Re-serialize just the Contacts portion back to JSOn
        String jsonSerialized = JSON.serialize((List<Object>) jsonResponseMap.get('Invoices'));

        // And finally parse the now re-serialized contact list back into Contact objects
        return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
    }    

}