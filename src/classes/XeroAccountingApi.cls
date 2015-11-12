/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Class to handle API calls for the Xero Accounting API resources
**/
public with sharing class XeroAccountingApi {

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Method to return ALL contacts for your Xero environment
	* 	@return List of Xero Contact wrapper classes
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
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Method to return ALL invoices for your Xero environment
	* 	@return List of Xero Invoice wrapper classes
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
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Custom exception class to throw errors for web service callouts
	**/
	public class XeroAccountingApiException extends Exception {}

}