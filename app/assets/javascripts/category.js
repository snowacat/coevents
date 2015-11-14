//= require jquery.min.js
//= require jquery.validate.js
//= require jquery.validate.additional-methods
//= require chosen.jquery.js

var ERROR_FIELD_CLASS = "errorField";

$(document).ready(function() {
    // Validate rules for create and update user page
    var currentPage = $('#userId').val();
    // If current page without user_id it's create new user page
    if (currentPage == '') {
        $("#userForm").validate({
            rules: {
                title: {
                    required: true,
                    rangelength: [0, 64]
                }
            },
            errorClass: "error",
            validClass: "valid",
            highlight: function(element, errorClass, validClass) {
                $(element).addClass(errorClass).removeClass(validClass);
                $(element).parent().removeClass().addClass('control-group error');
            },
            unhighlight: function( element, errorClass, validClass ) {
                $(element).removeClass(errorClass).addClass(validClass);
                $(element).removeClass(ERROR_FIELD_CLASS).addClass(validClass);
                $(element).prev().removeClass();
                $(element).parent().removeClass().addClass('inputBox');
            }
        });
    }
    else {
        $("#userForm").validate({
            rules: {
                title: {
                    required: true,
                    rangelength: [0, 64]
                }
            },
            errorClass: "error",
            validClass: "valid",
            highlight: function(element, errorClass, validClass) {
                $(element).addClass(errorClass).removeClass(validClass);
                $(element).parent().removeClass().addClass('control-group error');
            },
            unhighlight: function( element, errorClass, validClass ) {
                $(element).removeClass(errorClass).addClass(validClass);
                $(element).removeClass(ERROR_FIELD_CLASS).addClass(validClass);
                $(element).prev().removeClass();
                $(element).parent().removeClass().addClass('inputBox');
            }
        });
    }
});

