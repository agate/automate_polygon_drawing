var MAP_PAGE = './map.html',
    page = require( 'webpage' ).create(),
    evt;

page.viewportSize = { width: 600, height: 600 };
page.open(MAP_PAGE, function (status) {
  setTimeout(function () {
    page.render('map.png');
    phantom.exit();
  }, 3000);
});
