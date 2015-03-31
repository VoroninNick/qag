$(document).on('click', '#event_subscriptions_table button',function (event) {
    event.preventDefault()
    var $button = $(this)
    var $row = $button.closest('tr')
    var disabled = $row.hasClass('disabled')
    var enabled = !disabled

    if(enabled){
        $row.removeClass("enabled").addClass("disabled")
        $button.removeClass("btn-danger").addClass("btn-success")
        $button.text("Enable")


    }
    else{
        $row.removeClass("disabled").addClass("enabled")
        $button.removeClass("btn-success").addClass("btn-danger")
        $button.text("Disable")
    }

    var $tbody = $row.parent()
    var $rows = $tbody.children()
    var total_count = $rows.length
    var allowed_count = $rows.filter('.enabled').length
    var disallowed_count = total_count - allowed_count
    $('#total_subscriptions_count').text(total_count)
    $('#allowed_subscriptions_count').text(allowed_count)
    $('#disallowed_subscriptions_count').text(disallowed_count)

    var event_subscription_id = $row.attr('data-event-subscription-id')

    $.ajax({
        type: "post",
        url: "/enable_event_substription",
        data: { event_subscription_id: event_subscription_id, enabled: disabled }
    })


});