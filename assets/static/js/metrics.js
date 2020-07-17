// Yandex.Metrika counter
(function(m,e,t,r,i,k,a){m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
m[i].l=1*new Date();k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)})
(window, document, "script", "https://mc.yandex.ru/metrika/tag.js", "ym");
ym(62609776, "init", {
  clickmap:true,
  trackLinks:true,
  accurateTrackBounce:true,
  webvisor:true,
  ecommerce:"dataLayer"
});


document.addEventListener('DOMContentLoaded', function(){
  var sign_up = document.querySelector("#sign-up-btn");
  if(sign_up){ sign_up.onclick = function () {addAction('registration', "#sign-up-btn-hidden");}; }
  var sign_in = document.querySelector("#sign-in-btn");
  if(sign_in){ sign_in.onclick = function () {addAction('sign_in', "#sign-in-btn-hidden");}; }
  var sign_up_end = document.querySelector("#sign-up-btn-end");
  if(sign_up_end){ sign_up_end.onclick = function () {addAction('end_registration', "#sign-up-btn-end-hidden");}; }
  var subscribe = document.querySelector("#subscribe-btn");
  if(subscribe){ subscribe.onclick = function () {addAction('subscribe', "#subscribe-btn-hidden");}; }
  var item_add = document.querySelector("#item-add-btn");
  if(item_add){ item_add.onclick = function () {addAction('to_cart', "#item-add-btn-hidden");}; }
  var to_order = document.querySelector("#to-order-btn");
  if(to_order){ to_order.onclick = function () {addAction('to_order', "#to-order-btn-hidden");}; }
  var send_order = document.querySelector("#send-order-btn");
  if(send_order){ send_order.onclick = function () {addAction('send_order', "#send-order-btn-hidden");}; }
});

var addAction = function(action, selector){
  ym(62609776, 'reachGoal', action);
  document.querySelector(`${selector}`).click();
}


// // <!-- Global site tag (gtag.js) - Google Analytics -->
// window.dataLayer = window.dataLayer |[];
// function gtag(){dataLayer.push(arguments);}
// gtag('js', new Date());
// gtag('config', 'UA-165678985-1');


// // Google Tag Manager
// (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
// new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
// j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
// 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
// })(window,document,'script','dataLayer','GTM-TD6WH7S');
