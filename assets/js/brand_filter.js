$( ".brand-input" ).change(function() {
  brand_filter();
});

function brand_filter(){
  var url = window.location;
  var urlObject = new URL(url);


  var brands_arr = Array.from(document.getElementsByClassName("brand-input")).map(function callback(val) {
    if (val.checked == true){
      return val.id;
    };
  }).filter(val => val != null)

  urlObject.searchParams.set('brands', brands_arr);

  var destination_url = location.protocol + '//' + location.host + location.pathname;
  window.location = `${destination_url}?${urlObject.searchParams.toString()}`;
}
