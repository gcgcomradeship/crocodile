$( "#page_size" ).change(function() {
  set_param('page_size', this.value);
});

$( "#page_sort" ).change(function() {
  set_param('sort', this.value);
});

function set_param(param, value){
  var url = window.location;
  var urlObject = new URL(url);

  urlObject.searchParams.set(param, value);

  var destination_url = location.protocol + '//' + location.host + location.pathname;
  window.location = `${destination_url}?${urlObject.searchParams.toString()}`;
}
