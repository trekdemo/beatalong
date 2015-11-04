$(document).ready(function(){
  $('.track-click').on('click', function(e){
    if (typeof(ga) !== 'undefined')
      ga('send', 'pageview', e.target.getAttribute("href"));
  });
});
