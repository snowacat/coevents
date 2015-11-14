//= require jquery.min.js
//= require jquery.dotdotdot.js

$(document).ready(function() {
    $('.listCountry').dotdotdot({
        after: 'a.more',
        callback: dotdotdotCallback
    });

    $(".listCountry").on('click','a', function() {
        if ($(this).text() == "More") {
            var div = $(this).closest('.listCountry');
            div.trigger('destroy').find('a.more').hide();
            $(".listCountry").css({"max-height":"9000px"});
            $("a.less", div).show();
        }
        else {
            $(this).hide();
            $(this).closest('.listCountry').css("max-height", "20px").dotdotdot({ after: "a.more", callback: dotdotdotCallback });
        }
    });

    function dotdotdotCallback(isTruncated, originalContent) {
        if (!isTruncated) {
            $("a", this).remove();
        }
    }
});
