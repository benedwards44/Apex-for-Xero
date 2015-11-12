/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Test class for the Xero API methods
**/
@isTest
public class XeroAccountingApiTest {

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test a successful callout of the getContacts() method
	**/
	@isTest
	static void getContactsSuccess() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(200));

		Test.startTest();

		// Execute the callout
		List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();

		Test.stopTest();

		// Assert that a contact exists
		system.assert(
			xeroContacts.size() == 1,
			'There should be one contact returned from the callout'
		);
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the getContacts() method
	**/
	@isTest
	static void getContactsFail() {

		// Set the Mock Class for the callout
		Test.setMock(HttpCalloutMock.class, getStaticMock(500));

		Test.startTest();

		// Execute the callout
		try {

			List<XeroContact> xeroContacts = XeroAccountingApi.getContacts();
		} 
		catch (Exception ex) {

			// Error expected, as failed callout raises an exception
			system.assert(
				String.valueOf(ex).contains('500'),
				'The 500 error code should be contained in the string.'
			);
		}

		Test.stopTest();
	}

	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test scenario where no Xero Settings can be found
	**/
	@isTest
	static void getXeroSettingsError() {

		// Delete the Xero Settings created
		delete [Select Id From Xero_Setting__c];

		// Assert no Xero Settings found in Utility
		system.assert(
			XeroCalloutUtility.xeroSettings.Id == null,
			'There should be no Xero Setting record found.'
		);

	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Test an unsuccessful callout of the getContacts() method
	**/
	private static StaticResourceCalloutMock getStaticMock (Integer responseCode) {

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource('XeroGetContactsMock');
		mock.setStatusCode(responseCode);
		mock.setHeader('Content-Type', 'application/json');

		return mock;
	}


	/**
	* 	@author Ben Edwards (ben@benedwards.co.nz)
	*	@description Create test data for the method
	**/
	@testSetup
	static void setupTestData() {

		// A Private Key used for testing
		// openssl genrsa -out mykey.pem 1024
		// openssl pkcs8 -topk8 -nocrypt -in mykey.pem -outform PEM  > pkcs8.key
		String dummyPrivateKey = 
			'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBALl2MR4LamZPVX0y'+
			'EEOTHkBMcIp5/mTl3du5Gwpa81aQV/ch624nWHNzytvIT7A6TQtDtla4r5Eydufs'+
			'/ZoKm218RYsWV0rf8VEi320P1wLOA06r312LgiiiQcrVZF89IiVr66c6PYS2/6FH'+
			'jmZ58+oWUAjDZcUNHCfF3xhWsehTAgMBAAECgYAUYME63OQ/A56QGA0jb6nWRM/k'+
			'10y1h3BeMTOgaqfsLgYMWITG4LneTa3Pgm4HHhDTGQiS9M4NtS7NgwPGhj3XlPjj'+
			'QqaNHRnSid9KQI3uTWUkqrHhVEpNkHimLltuohR+XN9Ugqz6LEc4vc0N5Ggx38yZ'+
			'cr9PUinATukPr4KpmQJBAN26qRF1oV5Ooj097i5/0yf0bI4zS8DSM7B9xk5MtJ9E'+
			'yOLvc6bMcLlfhdSeq62m51sMswQJz/rc8b1JNlhOdNcCQQDWIIHV4+kDHPRfrqUa'+
			'SUFgeEDK/10eEQz8EVpGi9ii8aUm6XPjBa9flsG36XK4deJGJHfdH6k5mVCsSG6u'+
			'xzzlAkBKfGpPczTCeagG6scY19gXlATjwFeyburuX1I++4Wx+2mA0vAHGKbFn1FW'+
			'G/eQXoFaFOoOcT1tCMwsymt3PuQBAkBZ9FYXESP2ltdiyu+5V0ULzfkKTrVDyE34'+
			'JyIRuPZNnc6PxktU+DJwqdi/9manb36bkP55+q8Q74OgnN1Ct5ixAkB1PwflteP/'+
			'5sRZIswj8nNe1PbDk9rIu7AK/cD1UaPWhQnmy8jenL6qcFQgL/U61dh1fb+SdFa5'+
			'Q6ZUQ6YDDqER';

		// Create a test Xero Setting record
		insert new Xero_Setting__c(
			Consumer_Key__c = '123456789',
			Consumer_Secret__c = '123456789',
			Endpoint__c = 'https://api.xero-test.com?param1=value1&param2=value2/',
			Private_Key__c = dummyPrivateKey
		);

	}
	
}