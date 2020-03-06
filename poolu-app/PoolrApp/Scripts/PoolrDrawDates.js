$(document).ready(function () {

    $("#btnSaveDrawDates").click(function () {
        var controls = ASPxClientControl.GetControlCollection();
        var cbo = controls.GetByName('cboTicketType');
        var ticketTypeId = cbo.GetValue();

        $.ajax({
            type: "POST",
            url: "/DrawDates/SaveDrawDates",
            data: '{ticketTypeId: "' + ticketTypeId + '" }',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response !== null && response.success) {
                    bootbox.alert(response.message, function () {
                        gridLotteryDrawDates.PerformCallback({ ticketTypeId: ticketTypeId });
                    });
                } 
            },
            error: function (response) {
                alert("error!"); 
            }
        });

    });

  
});

function cboTicketTypeIndexChanged(s, e) {
    gridLotteryDrawDates.PerformCallback({ ticketTypeId: s.GetValue() } );
}