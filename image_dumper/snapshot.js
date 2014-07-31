var MAP_PAGE = './tmp.html',
    page = require( 'webpage' ).create(),
    evt;

page.open(MAP_PAGE, function ( status ) {
  window.setTimeout(function() {
    page.render( 'map.png' );
    phantom.exit();
  }, 5000);
});
