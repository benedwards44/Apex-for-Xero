/**
* @author       Ben Edwards (ben@benedwards.co.nz)
* @description  Utility class for serialising an object into XML format for the Xero APIs
**/
public class XeroXmlUtility {

	// Control whether the XML lines should include null values
	public static Boolean includeNullValues = false;

	// Control whether to include the 1st XML line:
	// "<?xml version="1.0" encoding="UTF-8"?>"
	public static Boolean includeXmlLine = false;


	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Takes an generic object and converts to XML string
    *   @return XML String
    **/
	public static String serialize(Object objectToSerialize, String parentNode) {

		// First serialize to JSON, as this method is built into Apex
		String jsonString = JSON.serialize(objectToSerialize);

		// Create a parser so we can iterate over each JSON line
		JSONParser parser = JSON.createParser(jsonString);

        // Instantiate new document
        Dom.Document xmlDoc = new Dom.Document();

        // Create parent element
        Dom.XmlNode parentElement = xmlDoc.createRootElement(parentNode, null, null);

        // Process the JSON parser
        processJson (parser, parentElement);

    	// Convert the XML Doc into a string
    	String xmlString = xmlDoc.toXmlString();

    	// IF the 1st XML line is to be exclude it, remove it
    	if (!includeXmlLine) {
    		xmlString = xmlString.replace('<?xml version="1.0" encoding="UTF-8"?>','');
    	}

		return xmlString;
	}

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Dynamic method used to process JSON elements accordingly
    *   @return Nudda
    **/
    private static void processJson (JSONParser parser, Dom.XmlNode parentElement) {

    	// Iterate over each JSON line
		while (parser.nextToken() != null) {

			// If it's the start of a object
			if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

				// Process the object
				processJsonObject (parser, parentElement, parser.getCurrentName());
			}

			// If the element is for an array of child elements
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

				// Process the array
				processJsonArray (parser, parentElement);
			}

			// If it's standard value
			if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

				// Add the key value element to the XML
				addValueElement (parser, parentElement);
			}
    	}

    }

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Serialize a JSON object into XML
    *   @return Nudda
    **/
    private static void processJsonObject (JSONParser parser, Dom.XmlNode parentElement, String objectName) {

    	// Create child element for the object
		Dom.XmlNode objectElement = parentElement.addChildElement(removeX(objectName), null, null);

		while (parser.nextToken() != null) {

			// If the Array has ended
			if (parser.getCurrentToken() == JSONToken.END_OBJECT) {

				// Break out of the loop
				break;
			}

			// If it's the start of a object, process itself again
			if (parser.getCurrentToken() == JSONToken.START_OBJECT && parser.getCurrentName() != null) {

				// Process the object
				processJsonObject (parser, parentElement, parser.getCurrentName());
			}

			// If the element is for an array of child elements
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

				// Process the array
				processJsonArray (parser, parentElement);
			}

			if (acceptedValues.contains(String.valueOf(parser.getCurrentToken()))) {

				// Add value element to the XML
				addValueElement (parser, objectElement);
			}
		}
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Serialize a JSON object into XML
    *   @return Nudda
    **/
    private static void processJsonArray (JSONParser parser, Dom.XmlNode parentElement) {

    	// Create child element for the object
		Dom.XmlNode arrayElement = parentElement.addChildElement(removeX(parser.getCurrentName()), null, null);

		// Iterate over elements in the array
		while (parser.nextToken() != null) {

			// If the Array has ended, break out
			if (parser.getCurrentToken() == JSONToken.END_ARRAY) {

				break;
			}

			// If it's the start of the end
			if (parser.getCurrentToken() == JSONToken.START_OBJECT) {

				// Take the name of the parent array
				String arrayName = arrayElement.getName();

				// Remove the last character (not the most accurate way to do it)
				String singularNameOfArray = arrayName.substring(0, arrayName.length() - 1);

				// Process the JSON object
				processJsonObject (parser, arrayElement, singularNameOfArray);
			}

			// If the element is for an array of child elements
			if (parser.getCurrentToken() == JSONToken.START_ARRAY) {

				// Move to next token
				parser.nextToken();

				// Process the array
				processJsonArray (parser, parentElement);
			}
		}
    }

    /**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Adds the key value pair as XML
    *   @return Nudda
    **/
    private static void addValueElement (JSONParser parser, Dom.XmlNode parentElement) {

    	// Create value for the parent object
		Dom.XmlNode childElement = parentElement.addChildElement(removeX(parser.getCurrentName()), null, null);

		// Add the text
		childElement.addTextNode(parser.getText());
    }

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Removes the trailing _x on variable names. This is done as a workaround for reserved names by Apex
    *   @return XML String
    **/
	private static String removeX(String value) {
		return value.replace('_x','');
	}

	/**
    *   @author Ben Edwards (ben@benedwards.co.nz)
    *   @description Set of JSONToken Enums used to determine whether to include JSON value in the XML
    *   @return Set of JSONToken Enum strings
    **/
	private static Set<String> acceptedValues {

		get {
			// Value enums which determine the type of value in the JSON
			acceptedValues = new Set<String>{
				'VALUE_FALSE',
				'VALUE_NUMBER_FLOAT',
				'VALUE_NUMBER_INT',
				'VALUE_STRING',
				'VALUE_TRUE'
			};

			// If set to include null values, add it to the set
			if (includeNullValues) {
				acceptedValues.add('VALUE_NULL');
			}

			return acceptedValues;
		}
		set;
	}

}