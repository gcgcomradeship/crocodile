$(function () {
  init();
});

var init = function(){
  document.querySelectorAll(".like-btn").forEach(function (elem) {
    elem.onclick = function () {
      likeBlog(this);
    };
  });
}

var likeBlog = function(elem){
  let blog_id = elem.getAttribute("blog-id");
  fetch(`/blog/${blog_id}/like`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if(json.status == "success"){
        console.log(json.count);
        var count = elem.querySelector(".count");
        count.innerText = json.count;
        if (elem.classList.contains('liked')){
          elem.classList.remove("liked");
        } else {
          elem.classList.add("liked");
        }
      }
      return json;
    });
}
