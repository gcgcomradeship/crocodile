$(function () {
  init();
});

var init = function(){
  var approve_btn = document.querySelector("#approve-btn");
  var hide_btn = document.querySelector("#hide-btn");
  if (approve_btn && hide_btn){
    approve_btn.onclick = function () {
      approveItem(this);
    };
    hide_btn.onclick = function () {
      hideItem(this);
    };
  }
}

var approveItem = function(item){
  let item_id = item.getAttribute("item-id");
  fetch(` /admin/approve/${item_id}/approve`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      console.log(json);
      if (json.status == "success"){
       refreshItem();
      }else{
        clearItem();
      }
      return json;
    });
}

var hideItem = function(item){
  let item_id = item.getAttribute("item-id");
  fetch(` /admin/approve/${item_id}/hide`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if (json.status == "success"){
       refreshItem();
      }else{
        clearItem();
      }
      return json;
    });
}

var refreshItem = function(){
  fetch(`/admin/approve/refresh`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      drawItem(json);
      return json;
    });
}

var clearItem = function(){
  document.querySelector("#item-unapprove-count").innerText = 0;
  document.querySelector("#item-field").innerHTML = "";
}


var drawItem = function(json){
  document.querySelector("#item-unapprove-count").innerText = json.count;
  document.querySelector("#approve-item-title").innerText = json.item_title;
  document.querySelector("#approve-btn").setAttribute("item-id", json.item_id);
  document.querySelector("#hide-btn").setAttribute("item-id", json.item_id);
  var images_tag = document.querySelector("#approve-item-images");
  images_tag.innerHTML = "";

  json.item_images.forEach(function (src) {
    addImage(images_tag, src);
  });
}

var addImage = function(parent, src){
  var img_tag = document.createElement("img");
  img_tag.setAttribute("src", src);
  parent.appendChild(img_tag);
}
