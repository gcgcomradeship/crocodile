$(function () {
  init();
});

var init = function(){
  $('#ageModal').on('hidden.bs.modal', function () {
    show();
  })
  show();
  var approve_btn = document.querySelector("#maturity-modal-btn");
  approve_btn.onclick = function () {
    approveMaturity();
  };
}

var show = function(){
  var maturity = document.querySelector("#ageModal").getAttribute("maturity");
  if (maturity != "true"){
    $('#ageModal').modal('show');
  }
}

var approveMaturity = function(elem){
  console.log("approve");
  $('#ageModal').modal('hide');
  fetch(`/maturity/approve`, {
    credentials: 'same-origin',
  })
    .then(response => {
      return response.json();
    })
    .then(json => {
      if(json.status == "success"){
        setMaturity();
      }
      return json;
    });
}

var setMaturity = function(){
  document.querySelector("#ageModal").setAttribute("maturity", "true");
}

