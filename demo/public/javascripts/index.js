function Index() {
  var self = this;

  this.center = new google.maps.LatLng(LAT, LNG);

  this.initHTML();
  this.initMap();

  setTimeout(function () {
    self.drawPolygon();
  }, 500);
}

Index.prototype.initHTML = function () {
  this.$map = $('#map-canvas');
}

Index.prototype.initMap = function () {
  this.map = new google.maps.Map(this.$map[0], {
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

  this.overlay = new google.maps.OverlayView();
  this.overlay.draw = function () {};
  this.overlay.setMap(this.map);
}

Index.prototype.pixelToLatlng = function (x, y) {
  var projection = this.overlay.getProjection();
  var point = new google.maps.Point(x, y);
  var latlng = projection.fromContainerPixelToLatLng(point);
  return latlng;
}

Index.prototype.latlngToPixel = function (latLng) {
  var projection = this.overlay.getProjection();
  return projection.fromLatLngToContainerPixel(latLng);
}

Index.prototype.drawPolygon = function () {
  var self = this;

  var center = this.latlngToPixel(this.map.getCenter());
  var latlngs = [];
  POINTS.forEach(function (p) {
    console.log(
      (p[0] - (DEFAULT_CENTER[0] - center.x)),
      (p[1] - (DEFAULT_CENTER[1] - center.y))
    );
    latlngs.push(self.pixelToLatlng(
      (p[0] - (DEFAULT_CENTER[0] - center.x)),
      (p[1] - (DEFAULT_CENTER[1] - center.y))
    ));
  });

  var polygon = new google.maps.Polygon({
    paths: latlngs
  });

  polygon.setMap(this.map);
}

google.maps.event.addDomListener(window, 'load', function () {
  window.index = new Index();
});
