function onUpdateSortableList(event) {
  var $el = $(event.target);
  var items = $.map($el.find("tr[data-sortable-position-id]"), function(item) {
    return $(item).data("sortable-position-id");
  });

  function handleSuccess(data) {}

  function handleError(error) {}

  $.ajax({
    url: $el.data('sortable-url'),
    method: 'POST',
    data: {
      item_ids: items,
    },
    success: handleSuccess,
    error: handleError,
  });
}

function initializeSortableList() {
  $("tbody[data-sortable-url]").each(function(index, element) {
    var $el = $(element);

    $el.sortable({
      sort: true,
      onUpdate: onUpdateSortableList,
    });
  });
}

$(document).on("ready", function() {
  initializeSortableList();
});
