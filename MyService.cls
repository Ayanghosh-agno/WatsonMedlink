/**
* @File Name : MyService.cls
* @Description :
* @Author : Ayan Ghosh
* @Last Modified By :
* @Last Modified On : November 17, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | November 17, 2024 |   | Initial Version
**/

@RestResource(urlMapping='/doctorAvailability')
global class MyService {
    // @HttpGet
    // global static void doGet() {
    //     RestContext.response.addHeader('Content-Type', 'text/plain');
    //     String name = RestContext.request.params.get('doctorName');
	// 	if (String.isNotBlank(name)) {
	// 		RestContext.response.responseBody = Blob.valueOf('{"success": true, "message": "Doctor Name is '+name+' Date is '+RestContext.request.params.get('Date')+' Time is '+RestContext.request.params.get('time')+'"}');
	// 		RestContext.response.statusCode = 200;
	// 	}else{
	// 		RestContext.response.responseBody = Blob.valueOf('{"success": false, "message": "Name parameter is required."}');
	// 		RestContext.response.statusCode = 400;
	// 	}
    // }


	@HttpGet
    global static void checkDoctorAvailability() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Retrieve parameters
        String location = req.params.get('location');
        String doctorName = req.params.get('doctorName');
        String dateInput = req.params.get('date');
        String timeInput = req.params.get('time');

        String patientPhone = req.params.get('patientPhone');
        String patientName = req.params.get('patientName');
        String patientEmail = req.params.get('patientEmail');
        String appointmentName = req.params.get('appointmentId');

        String appntMID = '';
        Boolean optionToBook = false;
        String conString = req.params.get('confirmation');
        if(String.isNotBlank(conString)){
                    optionToBook = Boolean.valueof(conString);
        }
        if(String.isNotBlank(appointmentName)){
            Appointment__c appnmt = [Select Id,Name,Location__c,Doctor__r.name,Patient__r.Name,Patient__r.Email__c,Patient__r.Phone_No__c from Appointment__c where name = : appointmentName];
                location = appnmt.Location__c ;
                appntMID = appnmt.Id;
                patientPhone = appnmt.Patient__r.Phone_No__c;
                patientEmail = appnmt.Patient__r.Email__c;
                patientName = appnmt.Patient__r.Name;
                doctorName = appnmt.Doctor__r.name;
        }


        // Split the string into hours, minutes, and seconds
        List<String> timeParts = timeInput.split(':');
        Integer hours = Integer.valueOf(timeParts[0]);
        Integer minutes = Integer.valueOf(timeParts[1]);
        Integer seconds = Integer.valueOf(timeParts[2]);

        // Create the original Time object
        Time originalTime = Time.newInstance(hours, minutes, seconds, 0);

        // Output the original time
        System.debug('Original Time: ' + originalTime);

        // Add 30 minutes to the time
        Integer totalMinutes = (originalTime.hour() * 60) + originalTime.minute() + 30; // Total minutes including the 30 added

        // Calculate the new hour and minute
        Integer newHour = totalMinutes / 60;
        Integer newMinute = totalMinutes - (newHour * 60); // Remaining minutes after calculating the hour
        Integer newSecond = originalTime.second();

        // If the new hour is greater than or equal to 24, adjust it to fit in a 24-hour range
        if (newHour >= 24) {
            newHour -= 24;  // Wrap around if it exceeds 24 hours
        }

        // Create the new Time object with the updated time
        Time newTime = Time.newInstance(newHour, newMinute, newSecond, 0);

        // Placeholder for checking doctor availability (customize logic as needed)
        //Boolean isAvailable = checkAvailability(doctorName, Date.valueOf(dateInput), Time.valueOf(timeInput), location);
        
        if(optionToBook){

            if(String.isNotBlank(appointmentName)){
                Appointment__c newAppointment = new Appointment__c();
                newAppointment.Start_Time__c = originalTime;
                newAppointment.End_Time__c = newTime;
                newAppointment.Appointment_Date__c = Date.valueOf(dateInput);
                newAppointment.Id = appntMID;
                update newAppointment;
                String responseMessage = 'Appointment is rescheduled for the Patient:<br><br><br>' +
                         'Patient Name: ' + patientName + '<br>' +
                         'Patient Email: ' + patientEmail + '<br>' +
                         'Patient Phone: ' + patientPhone + '<br> <br>' +
                         'with ' + doctorName + '<br>' +
                         'on ' + dateInput + ' at ' + timeInput + '<br><br>' +
                         'Location: ' + location + '<br><br>' +
                         'Please keep your Appointment Booking Id for any future reference - '+appointmentName+' .<br><br>' +
                         'You will also receive a confirmation Email. Thanks for contacting us.<br>';            
            
            res.responseBody = Blob.valueOf('{"success": true, "message": "' + responseMessage + '", "options": [],"suggestions":[]}');
            AppointmentEmailService.sendRescheduleEmail(patientEmail,patientName,dateInput,timeInput,location,doctorName);

            }else{
                String normalizedDoctorId = doctorName.replaceAll('\\.', '').trim();  // Removes only periods
                Doctor__c doc = [
    SELECT Name, Start_Time__c, End_Time__c, Slot_Duration__c, Working_Days__c
    FROM Doctor__c
    WHERE Name LIKE :('%' + normalizedDoctorId + '%')
    LIMIT 1
];
            List<Patient__c>  pp =[Select id from Patient__c where email__c = :patientEmail];
            Appointment__c newAppointment = new Appointment__c();
            if(pp.size() == 0){
                Patient__c pat = new Patient__c(Name = patientName, Email__c = patientEmail, Phone_No__c = patientPhone);
                insert pat;
                newAppointment.Patient__c = pat.Id;
            }else{     
                newAppointment.Patient__c = pp[0].Id;
            }
            newAppointment.Doctor__c = doc.Id;
            newAppointment.Appointment_Date__c = Date.valueOf(dateInput);
            newAppointment.Start_Time__c = originalTime;
            newAppointment.End_Time__c = newTime;
            newAppointment.Location__c = location;
            insert newAppointment;

            String appointmentId = [Select Id,name from Appointment__c where Id =:newAppointment.Id].Name;

            String responseMessage = 'Appointment is booked for the Patient:<br><br><br>' +
                         'Patient Name: ' + patientName + '<br>' +
                         'Patient Email: ' + patientEmail + '<br>' +
                         'Patient Phone: ' + patientPhone + '<br> <br>' +
                         'with ' + doctorName + '<br>' +
                         'on ' + dateInput + ' at ' + timeInput + '<br><br>' +
                         'Location: ' + location + '<br><br>' +
                         'Please keep your Appointment Booking Id for any future reference - '+appointmentId+' .<br><br>' +
                         'You will also receive a confirmation Email. Thanks for contacting us.<br>';            
            
            res.responseBody = Blob.valueOf('{"success": true, "message": "' + responseMessage + '", "options": [],"suggestions":[]}');
            AppointmentEmailService.sendBookingEmail(patientEmail,patientName,dateInput,timeInput,location,doctorName);
            }

            
            res.statusCode = 200;
        }else{
            Boolean isAvailable = SlotRecommendation.slotCheck(Date.valueOf(dateInput), originalTime, 4,doctorName);
            if (isAvailable) {
            // Doctor is available
            String responseMessage = 'Sure, Doctor ' + doctorName + ', is available on ' + dateInput + ' at ' + timeInput + ' at ' + location + '. Do you want to confirm booking?';
            responseMessage += ' (Yes / No)';
            res.responseBody = Blob.valueOf('{"success": true, "message": "' + responseMessage + '", "options": ["Yes", "No"],"suggestions":[]}');
            res.statusCode = 200;
        } else {
            // Doctor is not available; suggest alternative dates and timeInputs
            List<Map<String, String>> suggestions = SlotRecommendation.getAlternativeSlots(doctorName,Date.valueOf(dateInput), originalTime, 4);
            List<String> suggestionMessages = new List<String>();
            for (Map<String, String> suggestion : suggestions) {
                suggestionMessages.add(suggestion.get('date') + ' at ' + suggestion.get('time'));
            }
            res.responseBody = Blob.valueOf('{"success": false, "message": "Sorry, Doctor ' + doctorName + ' is not available on ' + dateInput + ' at ' + timeInput + '. Here are some alternatives:", "suggestions": ' + JSON.serialize(suggestionMessages) + ', "options": []}');
            res.statusCode = 200;
        }
        }
        //res.contentType = 'application/json';
    }

    // Example method to check availability (replace with actual logic)
    private static Boolean checkAvailability(String doctorName, String dateInput, String timeInput, String location) {
        // Sample logic to determine availability; return true or false based on actual data
        return Math.random() > 0.5;
    }

    // Example method to suggest alternative dates and times (replace with actual logic)
    private static List<Map<String, String>> suggestAlternativeTimes(String doctorName, String dateInput, String timeInput) {
        List<Map<String, String>> alternatives = new List<Map<String, String>>();

        // Sample logic for alternatives (add logic to calculate real alternative dates/times)
        for (Integer i = 1; i <= 4; i++) {
            Map<String, String> suggestion = new Map<String, String>();
            suggestion.put('date', '2024-11-' + String.valueOf(10 + i)); // Example future dates
            suggestion.put('time', '10:00 AM'); // Example times
            alternatives.add(suggestion);
        }
        return alternatives;
    }





}