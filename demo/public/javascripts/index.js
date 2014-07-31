function Index() {
  this.center = new google.maps.LatLng(LAT, LNG);

  this.initHTML();
  this.initMap();
}

Index.prototype.initHTML = function () {
  this.$map = $('#map-canvas');
}

Index.prototype.initMap = function () {
  var map = new google.maps.Map(this.$map[0], {
    center: this.center,
    zoom: 18,
    mapTypeId: google.maps.MapTypeId.SATELLITE,
    tilt: 0,

    mapTypeControl: false,
    overviewMapControl: false,
    panControl: false,
    rotateControl: false,
    scaleControl: false,
    streetViewControl: false,
    zoomControl: false,
  });
}

google.maps.event.addDomListener(window, 'load', function () {
  window.index = new Index();
});
