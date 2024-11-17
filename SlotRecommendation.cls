public class SlotRecommendation {
    
    public class Slot {
        public Date slotDate;
        public Time startTime;
        public Time endTime;
        public Boolean isAvailable;
        
        public Slot(Date slotDate, Time startTime, Time endTime, Boolean isAvailable) {
            this.slotDate = slotDate;
            this.startTime = startTime;
            this.endTime = endTime;
            this.isAvailable = isAvailable;
        }
    }
    
    public static boolean slotCheck(Date targetDate,Time targetTime,Integer suggestionsCount,String Doctorname ){
             
        // Example output (list of maps with date and time)
        List<Map<String, String>> availableSlots =SlotRecommendation.getAlternativeSlots(Doctorname,targetDate,targetTime,4);
        
        
        // Convert target date to 'yyyy-MM-dd' format manually
        String formattedTargetDate = targetDate.year() + '-' + String.valueOf(targetDate.month()) + '-' + String.valueOf(targetDate.day());
        
        // Manually format Time into 'hh:mm a' format
        String formattedTargetTime = SlotRecommendation.formatTime(targetTime);
        
        // Check if the target date and time are present in the available slots
        Boolean isSlotAvailable = false;
        
        for (Map<String, String> slot : availableSlots) {
            // Compare both date and time as strings
            if (slot.get('date') == formattedTargetDate && slot.get('time') == formattedTargetTime) {
                isSlotAvailable = true;
                break;
            }
        }        
        return isSlotAvailable;
    }
    
    public static List<Map<String, String>> getAlternativeSlots(
        String doctorId, 
        Date requestedDate, 
        Time requestedTime, 
        Integer suggestionsCount
    ) {
String normalizedDoctorId = doctorId.replaceAll('\\.', '').trim();  // Removes only periods


        // Fetch doctor's details
       Doctor__c doctor = [
    SELECT Name, Start_Time__c, End_Time__c, Slot_Duration__c, Working_Days__c
    FROM Doctor__c
    WHERE Name LIKE :('%' + normalizedDoctorId + '%')
    LIMIT 1
];

        List<Map<String, String>> alternatives = new List<Map<String, String>>();
        Date currentDate = requestedDate;
        Time currentRequestedTime = requestedTime;
        
        
        while (alternatives.size() < suggestionsCount) {
            Datetime dt = (DateTime)currentDate;
            // Check if currentDate is a valid working day
            String dayOfWeek = dt.format('EEE'); // E.g., "Mon", "Tue"
            if (doctor.Working_Days__c.contains(dayOfWeek)) {
                // Generate slots for the day
                List<Slot> slots = generateSlotsForDay(currentDate, doctor);
                
                // Check for the next available slots
                for (Slot slot : slots) {
                    if (slot.isAvailable && slot.startTime >= currentRequestedTime) {
                        Map<String, String> suggestion = new Map<String, String>();
                        suggestion.put('date', String.valueOf(slot.slotDate));
                        suggestion.put('time', formatTime(slot.startTime));
                        alternatives.add(suggestion);
                        
                        // Stop adding for the day once suggestionsCount is reached
                        if (alternatives.size() >= suggestionsCount) {
                            break;
                        }
                    }
                }
            }
            
            // Move to the next day if not enough slots are found
            currentDate = currentDate.addDays(1);
            currentRequestedTime = doctor.Start_Time__c; // Reset time for the next day
        }
        
        return alternatives;
    }
    
    public static List<Slot> generateSlotsForDay(Date dateT, Doctor__c doctor) {
        List<Slot> slots = new List<Slot>();
        Time currentTime = doctor.Start_Time__c;
        
        while (currentTime < doctor.End_Time__c) {
            Time slotEnd = currentTime.addMinutes(Integer.valueof(doctor.Slot_Duration__c));
            if (slotEnd <= doctor.End_Time__c) {
                slots.add(new Slot(dateT, currentTime, slotEnd, true));
            }
            currentTime = slotEnd;
        }
        
        // Query existing appointments for the date
        List<Appointment__c> bookedAppointments = [
            SELECT Start_Time__c, End_Time__c
            FROM Appointment__c
            WHERE Doctor__c = :doctor.Id
            AND Appointment_Date__c = :dateT
        ];
        
        // Mark overlapping slots as unavailable
        for (Slot slot : slots) {
            for (Appointment__c appointment : bookedAppointments) {
                if ((slot.startTime >= appointment.Start_Time__c && slot.startTime < appointment.End_Time__c) ||
                    (slot.endTime > appointment.Start_Time__c && slot.endTime <= appointment.End_Time__c)) {
                        slot.isAvailable = false;
                        break;
                    }
            }
        }
        
        return slots;
    }
    public static String formatTime(Time timeT) {
        Integer hour = timeT.hour();
        Integer minute = timeT.minute();
        String amPm = 'AM';
        
        if (hour >= 12) {
            amPm = 'PM';
            if (hour > 12) {
                hour -= 12; // Convert 24-hour time to 12-hour time
            }
        } else if (hour == 0) {
            hour = 12; // Midnight edge case
        }
        
        // Ensure minutes always have two digits
        String minuteString = (minute < 10) ? '0' + minute : String.valueOf(minute);
        
        return hour + ':' + minuteString + ' ' + amPm;
    }
}