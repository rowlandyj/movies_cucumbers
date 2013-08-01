$(function() {

  //fade in the first 8 posters and add the class to them
  $('.poster').slice(0,8).each(function(){
    $(this).addClass('fadeIn');
  });

  $(window).scroll(function() {
    $('.poster').each(function(){
      var imagePos = $(this).offset().top;
      var topOfWindow = $(window).scrollTop();
      if (imagePos < topOfWindow + 900) {
        $(this).addClass("fadeIn");
      }
    });
  });

});