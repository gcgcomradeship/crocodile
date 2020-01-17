$(function () {
  init();
});

var init = function(){
  document.querySelectorAll(".cart-delete-item").forEach(function (elem) {
    elem.onclick = function () {
      delCartItem(this);
    };
  });
  document.querySelectorAll(".nav-cart-delete-item").forEach(function (elem) {
    elem.onclick = function () {
      delCartItem(this);
    };
  });
  document.querySelectorAll(".item-count").forEach(function (elem) {
    elem.onchange = function (event) {
      if(event.target.value >= 1){
        setCount(this, event.target.value);
      }else{
        elem.value = 1;
        setCount(this, 1);
      }
    };
  });
}

var delCartItem = function(elem){
  let item_id = elem.getAttribute("item_id");
  fetch(`/cart/del_item?item_id=${item_id}`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if(json.status == "success"){
        document.querySelector(`#nav_cart_item_${item_id}`).remove();
        let cart_item = document.querySelector(`#cart_item_${item_id}`);
        if (cart_item) {
          cart_item.remove();
        }
        drawPrices();
        drawNavPrices();
      }
      return json;
    });
}

var setCount = function(elem, count){
  let item_id = elem.getAttribute("item_id");
  fetch(`/cart/set_count?item_id=${item_id}&count=${count}`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if(json.status == "success"){
        document.querySelector(`#cart_item_${item_id}`).setAttribute("count", count);
        document.querySelector(`#nav_cart_item_${item_id}`).setAttribute("count", count);
        drawPrices();
        drawNavPrices();
      }
      return json;
    });
}

var drawNavPrices = function(){
  list = document.querySelectorAll(".nav-cart-item").values();
  arr = Array.from(list).map(function(elem){
    let price = parseInt(elem.getAttribute("price"));
    let count = parseInt(elem.getAttribute("count")) || 1;
    let total = price * count;
    elem.querySelector(".nav-cart-count").textContent = `${count} x ₽ ${price}`;
    return total;
  });
  if (arr.length > 0){
    let sum = arr.reduce((sum, x) => sum + x);
    document.querySelector("#cart_total").textContent = `₽ ${sum}`;
  }else{
    document.querySelector("#cart_total").textContent = `₽ 0`;
  }
}

var drawPrices = function(){
  list = document.querySelectorAll(".cart-item").values();
  arr = Array.from(list).map(function(elem){
    let price = parseInt(elem.getAttribute("price"));
    let count = parseInt(elem.getAttribute("count")) || 1;
    let total = price * count;
    elem.setAttribute("total", total);
    elem.querySelector(".total-view").textContent = `₽${total}`;
    return total;
  });
  let total_elem = document.querySelector(".sum-total-view");
  if (arr.length > 0 && total_elem){
    let sum = arr.reduce((sum, x) => sum + x);
    document.querySelector(".sum-total-view").textContent = `₽${sum}`;
  }else if(total_elem){
    document.querySelector(".sum-total-view").textContent = `₽ 0`;
  }
}


