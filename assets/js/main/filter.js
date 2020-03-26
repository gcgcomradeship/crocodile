$(function () {
  init();
});

var init = function(){
  var reset = document.querySelector("#filter-reset");
  if(reset){
    reset.onclick = function () {
      resetFilter(this);
    };
  }
  var search = document.querySelector("#filter-search");
  if(search){
    search.onclick = function () {
      startSearch(this);
    };
  }
}

var startSearch = function(elem){
  var min_price = document.querySelector("#min_price").value;
  var max_price = document.querySelector("#max_price").value;
  var brand = document.querySelector(".brand_select").value;

  var url = window.location;
  var urlObject = new URL(url);
  if(min_price != ""){
    urlObject.searchParams.set("min_price", min_price);
  }else{
    urlObject.searchParams.delete("min_price", min_price);
  };
  if(max_price != ""){
    urlObject.searchParams.set("max_price", max_price);
  }else{
    urlObject.searchParams.delete("max_price", max_price);
  };
  if(brand != ""){
    urlObject.searchParams.set("brand", brand);
  }else{
    urlObject.searchParams.delete("brand", brand);
  };
  var destination_url = location.protocol + '//' + location.host + location.pathname;
  window.location = `${destination_url}?${urlObject.searchParams.toString()}`;
}

var resetFilter = function(elem){
  document.querySelector("#min_price").value = "";
  document.querySelector("#max_price").value = "";
  $('.brand_select').val("Все").trigger('change')
  search();
}
