
// Allows auto-complete label to have HTML.
try {
    $.ui.autocomplete.prototype._renderItem = function(ul, item) {
        return $( "<li></li>" )
        .data("item.autocomplete", item)
        .append($("<a></a>").html(item.label))
        .appendTo( ul );
    };
} catch (e) {
    console.log(e);
}

