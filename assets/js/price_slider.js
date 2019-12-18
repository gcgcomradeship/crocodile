var slider = document.getElementById('price_slider');
var maxprice_lim = parseInt(slider.getAttribute("max_price_lim"));
var maxprice = parseInt(slider.getAttribute("max_price"));
var minprice_lim = parseInt(slider.getAttribute("min_price_lim"));
var minprice = parseInt(slider.getAttribute("min_price"));

noUiSlider.create(slider, {
    start: [minprice, maxprice],
    connect: true,
    range: {
        'min': minprice_lim,
        'max': maxprice_lim
    },
    tooltips: true,
    step: 100,
    format: {
        to: function (value) {
            return Math.round(value);
        },
        from: function (value) {
            return Math.round(value);
        }
    }
});

slider.noUiSlider.on('change.one', function (val) {
  setPriceFilter(val[0], val[1]);
});

function setPriceFilter(minprice, maxprice){
  var url = window.location; // http://google.com?id=test
  var urlObject = new URL(url);
  urlObject.searchParams.set('minprice', minprice);
  urlObject.searchParams.set('maxprice', maxprice);
  var destination_url = location.protocol + '//' + location.host + location.pathname;
  window.location = `${destination_url}?${urlObject.searchParams.toString()}`;
}
