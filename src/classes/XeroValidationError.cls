/**
* @author Ben Edwards (ben@edwards.nz)
* @date 3rd February 2020
* @description Very simple class for generic Xero Validation Errors
**/
public class XeroValidationError {

    public String Message;

    /**
    *   @author Ben Edwards (ben@edwards.nz)
    *   @description Convert Xero Validation Errors into a single string
    *   @return Single error string
    **/
    public static String processValidationErrors(List<XeroValidationError> validationErrors) {

        String errors = '';

        for (XeroValidationError error :validationErrors) {

            errors += ('\n- ' + error.Message);
        }

        return errors;
    }
}