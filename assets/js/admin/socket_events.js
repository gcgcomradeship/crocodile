$(function () {
  document.addEventListener('phx:update', onUpdate);
});


var onUpdate = function(_event) {
  document.querySelectorAll(".dashboard_item_image").forEach(function (elem) {
    elem.onmouseover = function () {
      dashboarItemImagePreview(this);
    };
    elem.onmouseout = function () {
      dashboarItemImageHide(this);
    };
  });
}

var dashboarItemImagePreview = function(elem) {
  var preview_block = document.querySelector("#dashboard_item_image_preview");
  var preview_img = document.querySelector("#dashboard_item_image_preview img");
  preview_img.src = elem.src;
  preview_block.classList.remove('hide');
}

var dashboarItemImageHide = function(elem) {
  var preview_block = document.querySelector("#dashboard_item_image_preview");
  preview_block.classList.add('hide');
}
