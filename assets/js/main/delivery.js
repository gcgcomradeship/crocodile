$(function () {
  init();
});

var init = function(){
  document.getElementById('city').onchange = function () {
    on_change_city(this);
  };
  document.getElementById('address').onchange = function () {
    on_change_addres(this);
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
  document.querySelector("#delivery-price").innerText = `₽ ${delivery_price}`;
  document.querySelector("#total-price").innerText = `₽ ${total_price}`;
}

var exec_pick_up = function(elem){
  document.querySelector("#set-pick-point").classList.remove("hidden");
}

var exec_courier = function(elem){
}

var exec_post = function(elem){
  document.querySelector("#post-index").classList.remove("hidden");
}

var clear = function(){
  document.querySelector("#set-pick-point").classList.add("hidden");
  document.querySelector("#post-index").classList.add("hidden");
  document.getElementById('terminal_id').value="";
}

var pick_point_callback = function(result){
  console.log(result);
  // устанавливаем в скрытое поле ID терминала
  document.getElementById('terminal_id').value=result['id'];
  document.getElementById('post_index').value=result['postcode'];
  document.getElementById('city').value=result['city'] || result['region'];
  document.getElementById('delivery-city').innerText = result['city'] || result['region'];
  document.getElementById('delivery-address').innerText = result['address'];

  // показываем пользователю название точки и адрес доствки
  document.getElementById('address').value=result['address'];
}


var on_change_city = function(elem){
  document.getElementById('delivery-city').innerText = elem.value;
}

var on_change_addres = function(elem){
  document.getElementById('delivery-address').innerText = elem.value;
}
