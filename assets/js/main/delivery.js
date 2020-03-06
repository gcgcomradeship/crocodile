$(function () {
  init();
});

var init = function(){
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
  if(elem.value == "pick_up") exec_pick_up();
  if(elem.value == "courier") exec_courier();
  if(elem.value == "post") exec_post();
}

var exec_pick_up = function(){
  document.querySelector("#set-pick-point").classList.remove("hidden");
}

var exec_courier = function(){
}

var exec_post = function(){
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


  // показываем пользователю название точки и адрес доствки
  document.getElementById('address').value=result['address'];
}

