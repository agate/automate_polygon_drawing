var system = require('system'),
    page = require('webpage').create(),
    dir = system.args[1];

page.viewportSize = { width: 800, height: 800 };

page.open(dir + '/map.html', function (status) {
  page.onCallback = function(data) {
    setTimeout(function () {
      page.render(dir + '/map.png');
      phantom.exit();
    }, 50);
  }

  page.evaluate(function() {
    google.maps.event.addListenerOnce(map, 'tilesloaded', function() {
      window.callPhantom();
    });
  });
});
