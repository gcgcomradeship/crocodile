$(function () {
  init();
});

var init = function(){
  document.querySelectorAll(".quick-view-btn").forEach(function (elem) {
    elem.onclick = function () {
      drawItem(this);
    };
  });
}

var drawItem = function(elem){
  let item_id = elem.getAttribute("item-id");
  let cart_btn = document.querySelector("#modal-item-cart");
  let image = document.querySelector("#modal-item-img");
  let title = document.querySelector("#modal-item-title");
  let price = document.querySelector("#modal-item-price");
  let desc = document.querySelector("#modal-item-desc");
  let link = document.querySelector("#modal-item-link");
  fetch(`/modal/item?item_id=${item_id}`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      image.setAttribute("src", json.item.image);
      cart_btn.setAttribute("item-id", item_id);
      link.setAttribute("href", `/item/${item_id}`);
      title.textContent = json.item.title;
      price.textContent = json.item.price;
      desc.textContent = json.item.description;
      return json;
    });
}
