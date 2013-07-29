//same as $(document).ready()
$(function() {
  $('#brand').addClass('slideDown');
  $('.poster').slice(0,3).each(function(){
  $(this).addClass('bigEntrance');
    });
  $(window).scroll(function() {
    $('.poster').each(function(){
    var imagePos = $(this).offset().top;

    var topOfWindow = $(window).scrollTop();
      if (imagePos < topOfWindow+ 400) {
        $(this).addClass("bigEntrance");
      }
    });
  });

  $('.ratings-movie').mouseover(function(e){
    $(this).addClass("");
  });

  var filled_in_star = '\u2605';
  var hollow_star = '☆';

  $(".movie-rating-value").on("ajax:success", function (e, data, status, xhr) {

    var $movie_rating = $(this).closest('div.ratings-movie');
    if (window.location.pathname === "/recommendations" || window.location.pathname === "/ratings") {
      var title = $movie_rating.find('div.title');
      title.append('<h4>Movie rated: ' + data.rating_value + '</h4>');
      title.find('p').fadeOut(1600);
      $movie_rating.hide(800);
    } else if (window.location.pathname === "/users/ratings") {
      $movie_rating.find('p').text('Your current rating: ' + data.rating_value);
    }


  }).on("ajax:error", function (e, xhr, status, error) {
    var $movie_rating = $(this).closest('div.ratings-movie');
    if (window.location.pathname === "/recommendations" || window.location.pathname === "/ratings") {
      var title = $movie_rating.find('div.title');
      title.append('<h4>Movie rated: Aleady rated</h4>');
      title.find('p').fadeOut(1600);
    } else if (window.location.pathname === "/users/ratings") {
      $movie_rating.find('p').text("Movie already rated.");
    }

  }).mouseover(function (e) {
    $(this).text(filled_in_star);
    $(this).prevAll().text(filled_in_star);
  }).mouseout(function (e) {
    $(this).text(hollow_star);
    $(this).prevAll().text(hollow_star);
  });



});
