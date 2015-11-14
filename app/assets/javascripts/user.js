//= require jquery.min.js
//= require jquery.datetimepicker
//= require jquery.validate.js
//= require jquery.validate.additional-methods
//= require chosen.jquery.js

var ERROR_FIELD_CLASS = "errorField";

$(document).ready(function() {
    // Birth Date
    $('#pickerBirthDate').datetimepicker({
        lang:'en',
        format:'Y.m.d',
        timepicker: false
    });

    // Show country box, if checkbox checked
    $("#verified").click(function(){
        $(".fieldBoxCountries").toggle(300);
    });

    // Config for countries box
    var config = {
        '.chosen-select'           : {},
        '.chosen-select-deselect'  : {allow_single_deselect:true},
        '.chosen-select-no-single' : {disable_search_threshold:10},
        '.chosen-select-no-results': {no_results_text:'Oops, nothing found!'},
        '.chosen-select-width'     : {width:"95%"}
    };

    for (var selector in config) {
        $(selector).chosen(config[selector]);
    }

    // Validate rules for create and update user page
    var currentPage = $('#userId').val();
    // If current page without user_id it's create new user page
    if (currentPage == '') {
        $("#userForm").validate({
            rules: {
                user_name: {
                    required: true,
                    rangelength: [0, 64]
                },
                email: {
                    required: true,
                    rangelength: [0, 255],
                    email: true
                },
                phone_number: {
                    rangelength: [0, 20]
                },
                password: {
                    required: true,
                    rangelength: [0, 128]
                },
                password_confirmation: {
                    required: true,
                    rangelength: [0, 128]
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
                user_name: {
                    required: true,
                    rangelength: [0, 64]
                },
                email: {
                    required: true,
                    rangelength: [0, 255],
                    email: true
                },
                phone_number: {
                    rangelength: [0, 20]
                },
                password: {
                    rangelength: [0, 128]
                },
                password_confirmation: {
                    rangelength: [0, 128]
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

    if ($('#verified').is(":checked")) {
        $(".fieldBoxCountries").show();
    }
    else {
        $(".fieldBoxCountries").hide();
    }

    jQuery.validator.addMethod('selectcheck', function (value) {
        return (value != '');
    }, "This field is required.");
});

