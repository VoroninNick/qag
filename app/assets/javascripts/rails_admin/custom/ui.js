$(document).on('click', '#event_subscriptions_table button',function (event) {
    event.preventDefault()
    var $button = $(this)
    var $row = $button.closest('tr')
    var button_type = "";
    var event_subscription_id = $row.attr('data-event-subscription-id')
    if ($button.hasClass("toggle-disabled")){
        button_type = "toggle-disabled"
    }
    else if ($button.hasClass("toggle-archive")){
        button_type = "toggle-archive"
    }

    var button_toggle_disabled = button_type == "toggle-disabled"
    var button_toggle_archive = button_type == "toggle-archive"

    if (button_toggle_disabled) {
        var disabled = $row.hasClass('disabled')
        var enabled = !disabled

        if (enabled) {
            $row.removeClass("enabled").addClass("disabled")
            $button.removeClass("btn-danger").addClass("btn-success")
            $button.text("Допустити")
        }
        else {
            $row.removeClass("disabled").addClass("enabled")
            $button.removeClass("btn-success").addClass("btn-danger")
            $button.text("Заблокувати")
        }

        var $tbody = $row.parent()
        var $rows = $tbody.children()
        var total_count = $rows.length
        var allowed_count = $rows.filter('.enabled').length
        var disallowed_count = total_count - allowed_count
        $('#total_subscriptions_count').text(total_count)
        $('#allowed_subscriptions_count').text(allowed_count)
        $('#disallowed_subscriptions_count').text(disallowed_count)



        $.ajax({
            type: "post",
            url: "/enable_event_substription",
            data: { event_subscription_id: event_subscription_id, enabled: disabled }
        })
    }
    else if (button_toggle_archive){
        var archived = $row.hasClass("archived")
        if (archived){
            $row.removeClass("archived")
            $button.text("В архів")
        }
        else{
            $row.addClass("archived")
            $button.text("Відновити з архіву")
        }


        $.ajax({
            type: "post",
            url: "/archive_event_substription",
            data: { event_subscription_id: event_subscription_id, archived: !archived }
        })
    }


});