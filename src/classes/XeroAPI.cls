/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Handle calls to the Xero API
**/
public with sharing class XeroAPI {

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve a Xero Contact
    **/
    public static XeroContact getContact(String xeroId) {

        String resourceName = 'Contacts';

        // Callout to Xero to retrieve a single Contact
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId);

        if (response.getStatusCode() < 300) {

            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);

            List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);

            // Now serialise the response and reutrn
            return xeroContacts[0];
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving contact: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve modified invoices from Xero
    **/
    public static List<XeroContact> getContacts() {

        String resourceName = 'Contacts';

        // Callout to Xero to retrieve contacts
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName);

        if (response.getStatusCode() < 300) {

            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);

            // Now serialise the response and reutrn
            return (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving contacts: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }


    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Send a XeroContact to Xero
    **/
    public static XeroContact sendContact (XeroContact xeroContact) {

        String resourceName = 'Contacts';

        // Send the Contact to Xero
        HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroContact.serialize());

        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;

        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {

            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else {

            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');

            // Now serialise the response
            List<XeroContact> xeroContacts = (List<XeroContact>) JSON.deserialize(jsonSerialized, List<XeroContact>.class);

            // If success
            if (isSuccess) {

                return xeroContacts[0];
            }
            // else, process the error
            else {

                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';

                if (xeroContacts[0].ValidationErrors != null && !xeroContacts[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(xeroContacts[0].ValidationErrors);
                }

                throw new XeroApiException(xeroError);
            }
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve invoice from Xero
    **/
    public static XeroInvoice getInvoice(String xeroId) {

        String resourceName = 'Invoices';

        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName + '/' + xeroId);

        if (response.getStatusCode() < 300) {

            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);

            List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);

            // Now serialise the response and reutrn
            return xeroInvoices[0];
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve modified invoices from Xero
    **/
    public static List<XeroInvoice> getInvoices() {

        return getInvoices(null);
    }


    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve modified invoices from Xero
    **/
    public static List<XeroInvoice> getInvoices(Integer daysAgo) {

        String resourceName = 'Invoices';

        Map<String, String> modifiedHeader = null;

        if (daysAgo != null) {

            // Build the modified header
            modifiedHeader = new Map<String, String>{
                'If-Modified-Since' => getModifiedDateFilterFormatted(daysAgo)
            };
        }

        // Callout to Xero to retrieve invoices to update
        HttpResponse response = XeroCalloutService.executeCallout('GET', resourceName, null, modifiedHeader);

        if (response.getStatusCode() < 300) {

            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), resourceName);

            // Now serialise the response and reutrn
            return (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoices: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve invoice from Xero
    **/
    public static Blob getInvoiceAsPdf(String xeroId) {

        String resourceName = 'Invoices';

        // Callout to Xero to retrieve invoice
        HttpResponse response = XeroCalloutService.executeCallout(
            'GET', resourceName + '/' + xeroId,
            null,
            new Map<String, String>{'Accept' => 'application/pdf'}
        );

        if (response.getStatusCode() < 300) {

            return response.getBodyAsBlob();
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving invoice: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }


    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Send a Salesforce Invoice to Xero as an Invoice
    **/
    public static XeroInvoice sendInvoice (XeroInvoice xeroInvoice) {

        String resourceName = 'Invoices';

        // Send the Invoice to Xero as an Invoice
        HttpResponse response = XeroCalloutService.executeCallout('POST', resourceName, xeroInvoice.serialize());

        // Determine if message was successfully sent
        Boolean isSuccess = response.getStatusCode() < 300;

        // 401 errors are in a different format
        // So need to process in a different way
        if (response.getStatusCode() == 401) {

            throw new XeroApiException(XeroUtils.process401Error(response.getBody()));
        }
        else {

            // Cast back to a Xero Contact
            String jsonSerialized = XeroUtils.generateJsonStringForParsing(response.getBody(), isSuccess ? resourceName : 'Elements');

            // Now serialise the response
            List<XeroInvoice> xeroInvoices = (List<XeroInvoice>) JSON.deserialize(jsonSerialized, List<XeroInvoice>.class);

            // If success
            if (isSuccess) {

                return xeroInvoices[0];
            }
            // else, process the error
            else {

                // Store the error
                String xeroError = response.getStatusCode() + ': ' + response.getStatus() + '\n';

                if (xeroInvoices[0].ValidationErrors != null && !xeroInvoices[0].ValidationErrors.isEmpty()) {
                    xeroError += XeroValidationError.processValidationErrors(xeroInvoices[0].ValidationErrors);
                }

                throw new XeroApiException(xeroError);
            }
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Retrieve the latest Xero ID to use for the Xero Tenant ID
    **/
    public static String getXeroTenantId () {

        // Callout to Xero to retrieve contacts
        HttpResponse response = XeroCalloutService.executeCallout('GET', 'connections');

        if (response.getStatusCode() < 300) {

            // Retrieve the Xero Connection
            List<XeroConnection> xeroConnections = (List<XeroConnection>) JSON.deserialize(response.getBody(), List<XeroConnection>.class);

            system.debug('### Latest Xero Tenant ID is:' + xeroConnections[0].tenantId);

            // Now serialise the response and reutrn
            return xeroConnections[0].tenantId;
        }
        else {

            // Throw exception
            throw new XeroApiException(
                'Error retrieving connections: ' + response.getStatusCode() + ' - ' + response.getStatus() + '\n\n' +
                response.getBody()
            );
        }
    }

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description For a given number of days ago, set the invoice filter
    **/
    public static String getModifiedDateFilterFormatted (Integer daysAgo) {

        // Go back the # days ago
        Date modifiedDate = System.today().addDays(daysAgo * -1);

        // Format the date into correct xero format
        // https://developer.xero.com/documentation/api/invoices#get
        return ((DateTime)modifiedDate).format('yyyy-MM-dd') + 'T00:00:00';
    }

    public class XeroApiException extends Exception {}
}