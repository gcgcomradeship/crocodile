$(function () {
  if (document.getElementById('city')){
    init();
  }
});

var init = function(){
  document.getElementById('city').onchange = function () {
    on_change_city(this);
  };
  document.getElementById('area').onchange = function () {
    on_change_addres();
  };
  document.getElementById('street').onchange = function () {
    on_change_addres();
  };
  document.getElementById('house').onchange = function () {
    on_change_addres();
  };
  document.getElementById('flat').onchange = function () {
    on_change_addres();
  };

  document.querySelectorAll(".delivery-radio").forEach(function (elem) {
    elem.onchange = function () {
      exec_type(this);
    };
  });
  document.querySelector("#set-pick-point").onclick = function () {
    PickPoint.open(pick_point_callback);
    return false;
  };
}

var exec_type = function(elem){
  clear();
  if(elem.value == "pick_up") exec_pick_up(elem);
  if(elem.value == "courier") exec_courier(elem);
  if(elem.value == "post") exec_post(elem);
  var delivery_price = parseInt(elem.getAttribute("price"));
  var items_price = parseInt(document.querySelector("#items-price").getAttribute("price"));
  var total_price = delivery_price + items_price;
  document.querySelector("#delivery-price").innerText = `${delivery_price} ₽`;
  document.querySelector("#total-price").innerText = `${total_price} ₽`;
}

var exec_pick_up = function(elem){
  document.querySelector("#set-pick-point").classList.remove("hidden");
  document.querySelector("#delivery-type").innerText = "Постамат";
}

var exec_courier = function(elem){
  document.querySelector("#delivery-type").innerText = "Курьер";
}

var exec_post = function(elem){
  document.querySelector("#post-index").classList.remove("hidden");
  document.querySelector("#delivery-type").innerText = "Почта";
}

var clear = function(){
  document.querySelector("#set-pick-point").classList.add("hidden");
  document.querySelector("#post-index").classList.add("hidden");
  document.getElementById('terminal_id').value="";
}

var pick_point_callback = function(result){
  document.getElementById('terminal_id').value=result['id'];
  document.getElementById('post_index').value=result['postcode'];
  document.getElementById('city').value=result['cityname'];
  document.getElementById('delivery-city').innerText = result['city'] || result['region'];

  // document.getElementById('address').value=result['address'];
  document.getElementById('area').value=result['region'];
  document.getElementById('street').value=result['shortaddress'].split(",")[0];
  document.getElementById('house').value=result['house'];
  var addres = result['region'] + ", " +
              result['shortaddress'].split(",")[0] + ", " +
              result['house'] + " " +
              document.getElementById('flat').innerText
  document.getElementById('delivery-address').innerText = addres;
}


var on_change_city = function(elem){
  document.getElementById('delivery-city').innerText = elem.value;
}

var on_change_addres = function(elem){
  document.getElementById('delivery-address').innerText =
    document.getElementById('area').value + ", " +
    document.getElementById('street').value + ", " +
    document.getElementById('house').value + " " +
    document.getElementById('flat').value
}
