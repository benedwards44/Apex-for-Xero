/**
* Author:       Ben Edwards
* Date:         2015-11-10
* Description:  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {

	/**
	*	Method to return ALL contacts for your Xero environment
	**/
	public static List<XeroContact> getContacts () {

		List<XeroContact> xeroContacts = new List<XeroContact>();

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout(XeroConstants.API_NAME_CONTACTS);

		// If successful response
		if (response.getStatusCode() == 200) {

			// Parse the JSON response
			Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

			// Re-serialize just the Contacts portion back to JSOn
			String jsonSerialized = JSON.serialize((List<Object>) jsonResponseMap.get(XeroConstants.API_NAME_CONTACTS));

			// And finally parse the now re-serialized contact list back into Contact objects
			xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		}

		return xeroContacts;
	}


	/**
	*	Method to return ALL invoices for your Xero environment
	**/
	public static List<XeroInvoice> getInvoices () {

		List<XeroInvoice> xeroInvoices = new List<XeroInvoice>();

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout(XeroConstants.API_NAME_INVOICES);

		// If successful response
		if (response.getStatusCode() == 200) {

			// Parse the JSON response
			Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

			// Re-serialize just the Contacts portion back to JSOn
			String jsonSerialized = JSON.serialize((List<Object>) jsonResponseMap.get(XeroConstants.API_NAME_INVOICES));

			// And finally parse the now re-serialized contact list back into Contact objects
			xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		}

		return xeroInvoices;
	}


	/**
	*	Custom exception class to handle response errors
	**/
	public class XeroAccountingApiException extends Exception {}

}