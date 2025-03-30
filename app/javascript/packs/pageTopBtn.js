// $(function() {
// });

$(document).on('turbolinks:load', function() {
  $('#back a').on('click',function(event){
    $('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
  // turbolinksを無効化したい処理
});