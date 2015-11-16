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
		HttpResponse response = XeroCalloutUtility.executeCallout('GET', 'Contacts', null);

		// If successful response
		if (response.getStatusCode() == 200) {

			// Parse the JSON response
			Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

			// Re-serialize just the Contacts portion back to JSOn
			String jsonSerialized = JSON.serialize((List<Object>) jsonResponseMap.get('Contacts'));

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
	*	@description Method to create a Contact in Xero. 
	* 	@return Returns the Contact Id of the Contact created in Xero
	**/
	public static String createContact (String contactBody) {

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Contacts', contactBody);

		// If successful response
		if (response.getStatusCode() == 200) {

			return 'Successfully created contact';
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		
			return null;
		}
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Method to create an invoice in Xero. 
	* 	@return Returns the invoice Id of the invoice created in Xero
	**/
	public static String createInvoice (String invoiceBody) {

		// Execute the callout to the Contacts GET resource
		HttpResponse response = XeroCalloutUtility.executeCallout('PUT', 'Invoices', invoiceBody);

		// If successful response
		if (response.getStatusCode() == 200) {

			return 'Successfully created invoice';
		}
		else {

			// Raise error
			throw new XeroAccountingApiException(response.getStatusCode() + ': ' + response.getBody());
		
			return null;
		}
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Custom exception class to throw errors for web service callouts
	**/
	public class XeroAccountingApiException extends Exception {}

}