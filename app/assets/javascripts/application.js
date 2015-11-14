//= require jquery.min.js
//= require jquery.validate.js
//= require jquery.validate.additional-methods


$(document).ready(function() {
    $("#loginForm").validate({
        rules: {
            login: {
                required: true,
                rangelength: [0, 255]
            },
            password: {
                required: true,
                rangelength: [0, 255]
            }
        },
        errorClass: "error",
        validClass: "valid",
        highlight: function(element, errorClass, validClass) {
            $(element).addClass(errorClass).removeClass(validClass);
            $(element).prev().removeClass().addClass('setErrorImg');
            $(element).parent().removeClass().addClass('control-group error');
        },
        unhighlight: function( element, errorClass, validClass ) {
            $(element).removeClass(errorClass).addClass(validClass);
            $(element).prev().removeClass();
            $(element).parent().removeClass().addClass('fieldBox');
        }
    });

    // Validate password reset form
    $("#passwordResetForm").validate({
        rules: {
            email: {
                required: true,
                rangelength: [0, 255],
                email: true
            }
        },
        errorClass: "error",
        validClass: "valid",
        highlight: function(element, errorClass, validClass) {
            $(element).addClass(errorClass).removeClass(validClass);
            $(element).prev().removeClass().addClass('setErrorImg');
            $(element).parent().removeClass().addClass('control-group error');
        },
        unhighlight: function( element, errorClass, validClass ) {
            $(element).removeClass(errorClass).addClass(validClass);
            $(element).prev().removeClass();
            $(element).parent().removeClass().addClass('fieldBox');
        }
    });

    // Validate password create form
    $("#passwordCreateForm").validate({
        rules: {
            password: {
                required: true,
                rangelength: [0, 255]
            },
            passwordConfirmation: {
                required: true,
                rangelength: [0, 255]
            }
        },
        errorClass: "error",
        validClass: "valid",
        highlight: function(element, errorClass, validClass) {
            $(element).addClass(errorClass).removeClass(validClass);
            $(element).prev().removeClass().addClass('setErrorImg');
            $(element).parent().removeClass().addClass('control-group error');
        },
        unhighlight: function( element, errorClass, validClass ) {
            $(element).removeClass(errorClass).addClass(validClass);
            $(element).prev().removeClass();
            $(element).parent().removeClass().addClass('fieldBox');
        }
    });
});