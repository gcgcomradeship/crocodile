$(function () {
  setFlashToItem();
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
  document.querySelectorAll(".cart-btn").forEach(function (elem) {
    elem.onclick = function () {
      addItem(this);
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
        cartCounter(json.cart);
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
        cartCounter(json.cart);
      }
      return json;
    });
}

var addItem = function(elem){
  let item_id = elem.getAttribute("item-id");
  fetch(`/cart/add_item?item_id=${item_id}`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if(json.status == "success"){
        drawItems(json.cart);
      }
      return json;
    }).then(json => {
      init();
      cartCounter(json.cart);
      drawPrices();
      drawNavPrices();
      return json;
    });
}

var cartCounter = function(cart){
  document.querySelector(`#cart-counter`).innerText = cart.length;
  var cart_side = document.querySelector(`#cart-counter-side`);
  if (cart_side){
    cart_side.innerText = cart.length;
  }
}

var drawItems = function (json) {
  var cart = document.querySelector(`#cart`);

  for (item of json){
    var cart_li = document.querySelector(`#nav_cart_item_${item.item_id}`);
    if (cart_li){
      cart_li.outerHTML = cartItem(item);
    }else{
      var tag = document.createElement("div");
      tag.innerHTML = cartItem(item);
      while (tag.firstChild) {
        cart.insertBefore(tag.firstChild, cart.firstChild);
      }
    }
  }
};

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

var cartItem = function(json){
  var html =
  `<li class="nav-cart-item" count=${json.count} id="nav_cart_item_${json.item_id}" price="${json.price}">
    <div class="media">
      <a href="/item/${json.item_id}">
        <img class="mr-3" src="${json.image}">
      </a>
      <div class="media-body">
        <a href="/item/${json.item_id}">
          <h4>${json.title}</h4>
        </a>
        <h4>
          <span class="nav-cart-count">${json.count} x ₽ ${json.price}</span>
        </h4>
      </div>
    </div>
    <div class="close-circle nav-cart-delete-item" item_id="${json.item_id}">
      <a href="#">
        <i aria-hidden="true" class="fa fa-times"></i>
      </a>
    </div>
  </li>`;
  return html;
}

var setFlashToItem = function(){
  $('.cart-btn-product').on('click', function () {
    var successOptions = {
      autoHideDelay: 20000,
      showAnimation: "fadeIn",
      hideAnimation: "fadeOut",
      hideDuration: 700,
      arrowShow: false,
      className: "success",
    };

    $.notify("Продукт добавлен в корзину", successOptions);
  });
}
