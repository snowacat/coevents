//= require jquery.min.js

$(document).ready(function() {
    $("#send_message").click(function(){
        if ($('#send_message').is(":checked")) {
            window.location.replace('/events?send_message=true');
            $("#send_message").checked(false);
        }
        else {
            window.location.replace('/events');
            $("#send_message").checked(true);
        }
    });
});