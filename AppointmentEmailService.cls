/**
* @File Name : sendemailhelper.cls
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

public class AppointmentEmailService {

    // Method to send Appointment Booking email
    public static void sendBookingEmail(String recipientEmail, String recipientName, String appointmentDate, String appointmentTime, String location,String doctor) {
        sendEmail(
            recipientEmail, 
            'Appointment Confirmation', 
            '<html>' +
            '<head>' +
            '<style>' +
            'body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }' +
            '.email-container { width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }' +
            '.email-header { background-color: #007BFF; padding: 20px; color: white; text-align: center; border-radius: 8px 8px 0 0; }' +
            '.email-body { padding: 20px; line-height: 1.6; }' +
            '.button { display: inline-block; background-color: #28a745; color: white; padding: 12px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; margin-top: 10px; }' +
            '.footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }' +
            '</style>' +
            '</head>' +
            '<body>' +
            '<div class="email-container">' +
            '<div class="email-header"><h2>Appointment Confirmation</h2></div>' +
            '<div class="email-body">' +
            '<p>Dear ' + recipientName + ',</p>' +
            '<p>We are pleased to confirm your appointment with us. Below are the details:</p>' +
            '<p><strong>Appointment Details:</strong></p>' +
			'<p><strong>Doctor:</strong> ' + doctor + '</p>' +
            '<p><strong>Date:</strong> ' + appointmentDate + '</p>' +
            '<p><strong>Time:</strong> ' + appointmentTime + '</p>' +
            '<p><strong>Location:</strong> ' + location + '</p>' +
            '<p>If you need to make any changes, please click the button below:</p>' +
            '<a href="https://agno-dev-ed.develop.my.site.com/WatsonMedLink/s/" class="button">Manage Appointment</a>' +
            '</div>' +
            '<div class="footer">This is an automated message. Please do not reply.</div>' +
            '</div>' +
            '</body>' +
            '</html>'
        );
    }

    // Method to send Appointment Rescheduling email
    public static void sendRescheduleEmail(String recipientEmail, String recipientName, String newAppointmentDate, String newAppointmentTime, String location,String doctor) {
        sendEmail(
            recipientEmail, 
            'Appointment Rescheduled', 
            '<html>' +
            '<head>' +
            '<style>' +
            'body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }' +
            '.email-container { width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }' +
            '.email-header { background-color: #FF8C00; padding: 20px; color: white; text-align: center; border-radius: 8px 8px 0 0; }' +
            '.email-body { padding: 20px; line-height: 1.6; }' +
            '.button { display: inline-block; background-color: #28a745; color: white; padding: 12px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; margin-top: 10px; }' +
            '.footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }' +
            '</style>' +
            '</head>' +
            '<body>' +
            '<div class="email-container">' +
            '<div class="email-header"><h2>Appointment Rescheduled</h2></div>' +
            '<div class="email-body">' +
            '<p>Dear ' + recipientName + ',</p>' +
            '<p>Your appointment has been successfully rescheduled. Below are the new details:</p>' +
            '<p><strong>New Appointment Details:</strong></p>' +
			'<p><strong>Doctor:</strong> ' + doctor + '</p>' +
            '<p><strong>Date:</strong> ' + newAppointmentDate + '</p>' +
            '<p><strong>Time:</strong> ' + newAppointmentTime + '</p>' +
            '<p><strong>Location:</strong> ' + location + '</p>' +
            '<p>If you need further adjustments or have any questions, please use the link below:</p>' +
            '<a href="https://agno-dev-ed.develop.my.site.com/WatsonMedLink/s/" class="button">Manage Appointment</a>' +
            '</div>' +
            '<div class="footer">This is an automated message. Please do not reply.</div>' +
            '</div>' +
            '</body>' +
            '</html>'
        );
    }

    // Method to send Appointment Cancellation email
    public static void sendCancellationEmail(String recipientEmail, String recipientName, String originalAppointmentDate, String location,String doctor) {
        sendEmail(
            recipientEmail, 
            'Appointment Cancelled', 
            '<html>' +
            '<head>' +
            '<style>' +
            'body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }' +
            '.email-container { width: 100%; max-width: 600px; margin: 0 auto; background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); }' +
            '.email-header { background-color: #DC3545; padding: 20px; color: white; text-align: center; border-radius: 8px 8px 0 0; }' +
            '.email-body { padding: 20px; line-height: 1.6; }' +
            '.button { display: inline-block; background-color: #28a745; color: white; padding: 12px 20px; border-radius: 5px; text-decoration: none; font-weight: bold; margin-top: 10px; }' +
            '.footer { font-size: 12px; color: #777; text-align: center; margin-top: 20px; }' +
            '</style>' +
            '</head>' +
            '<body>' +
            '<div class="email-container">' +
            '<div class="email-header"><h2>Appointment Cancelled</h2></div>' +
            '<div class="email-body">' +
            '<p>Dear ' + recipientName + ',</p>' +
            '<p>We regret to inform you that your upcoming appointment has been cancelled. Below are the details of your cancelled appointment:</p>' +
            '<p><strong>Cancelled Appointment Details:</strong></p>' +
			'<p><strong>Doctor:</strong> ' + doctor + '</p>' +
            '<p><strong>' + originalAppointmentDate + '</strong></p>' +
            '<p><strong>Location:</strong> ' + location + '</p>' +
            '<p>If you would like to reschedule or need assistance, please click the link below:</p>' +
            '<a href="https://agno-dev-ed.develop.my.site.com/WatsonMedLink/s/" class="button">Reschedule Appointment</a>' +
            '</div>' +
            '<div class="footer">This is an automated message. Please do not reply.</div>' +
            '</div>' +
            '</body>' +
            '</html>'
        );
    }

    // Helper method to send the email
    private static void sendEmail(String recipientEmail, String subject, String body) {
        // Create the email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { recipientEmail });
        mail.setSubject(subject);
		OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address ='ayanghosh974@gmail.com'];
		mail.setOrgWideEmailAddressId(owea.get(0).Id);
        mail.setHtmlBody(body);  // Set the HTML body for the email

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}