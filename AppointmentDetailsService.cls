/**
* @File Name : AppointmentDetailsService.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : November 17, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 17, 2024 |   | Initial Version
**/

@RestResource(urlMapping='/appointment')
global class AppointmentDetailsService {

    @HttpGet
    global static void doGet() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        
        // Retrieve the AppointmentId from query parameters
        String appointmentId = RestContext.request.params.get('appointmentId');
        
        // Initialize response variables
        Boolean success = false;
        String message;
        
        if (String.isNotBlank(appointmentId)) {
            try {
                // Query to fetch appointment details based on AppointmentId
                Appointment__c appointment = [Select Id,Name,Doctor__r.name,Appointment_Date__c,Patient__r.Name,Patient__r.Email__c,Start_Time__c,End_Time__c,Patient__r.Phone_No__c,Location__c from Appointment__c where name = : appointmentId];
                
                // If appointment exists, construct the success response
                success = true;
				message = 'Appointment is Found ! <br>'+
							'Doctor - '+appointment.Doctor__r.name +'<br>'+
							'Location - '+appointment.Location__c + '<br>'+
							'On '+formatAppointment(appointment.Appointment_Date__c,appointment.Start_Time__c,appointment.End_Time__c);

            } catch (Exception e) {
                // Handle case where no appointment is found
                success = false;
                message = 'Appointment not found. Please try again with a different appointment ID';
            }
        } else {
            // Handle missing AppointmentId parameter
            success = false;
            message = 'AppointmentId parameter is required.';
        }
        
		RestContext.response.responseBody = Blob.valueOf('{"success": '+success+', "message":"'+message+'"}');
        // Set the appropriate status code
        RestContext.response.statusCode = success ? 200 : 400;
    }

	public static String formatAppointment(Date dateT, Time startTime, Time endTime) {
    // Combine the Date and Time into Datetime objects
    Datetime startDateTime = Datetime.newInstance(dateT, startTime);
    Datetime endDateTime = Datetime.newInstance(dateT, endTime);

    // Format the Date
   String formattedDate = dateT.year() + '-' + 
                           (dateT.month() < 10 ? '0' + String.valueOf(dateT.month()) : String.valueOf(dateT.month())) + '-' + 
                           (dateT.day() < 10 ? '0' + String.valueOf(dateT.day()) : String.valueOf(dateT.day()));

    
    // Format the Time in the user's timezone
    String formattedStartTime = startDateTime.format('h:mm a', 'en_US');
    String formattedEndTime = endDateTime.format('h:mm a', 'en_US');

    // Return the formatted response
    return 'Date: ' + formattedDate + ', Time: ' + formattedStartTime + ' to ' + formattedEndTime;
}
}