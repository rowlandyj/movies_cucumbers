//same as $(document).ready()
$(function() {
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

  });
});
