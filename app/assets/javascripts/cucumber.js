//same as $(document).ready()
$(function() {
  $('#brand').addClass('slideDown');
  $('.poster').slice(0,8).each(function(){
    $(this).addClass('fadeIn');
  });

  $('.pure-input-1-2').focus(function() {
    $('.pure-input-1-2').css('border','1px solid green');
  });


  $(".side-bar-icon").click( function(event){
    $(this).toggleClass('side-bar-icon-right');
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

  $('.ratings-movie').mouseover(function(e){
    $(this).addClass("");
  });


  var filled_in_star = '\u2605';
  var hollow_star = '☆';

  var hollow_stars = function (self) {
    $(self).text(hollow_star);
    $(self).siblings().text(hollow_star);
  };

  var fill_stars = function (self) {
    $(self).text(filled_in_star);
    $(self).prevAll().text(filled_in_star);
  };

  var fill_stars_upto_rating = function (self) {
    var rating = $(self).parent().data('current_rating');

    $(self).parent().find('.movie-rating-value').each( function(index) {
      if (index > (rating-1)) {
        return false; //this acts like break
      }
      $(this).text(filled_in_star);
    });
  };

  var updateStars_forAll = function ($movies) {
    $(document).find('.movie-rating-value').each( function(e) {
      fill_stars_upto_rating(this);
    });
  };

  $(".movie-rating-value").on("ajax:success", function (e, data, status, xhr) {
    var self = this;
    var $movie_rating = $(this).closest('div.ratings-movie');

    $movie_rating.find('.rating').data('current_rating', data.rating_value);

    // "/ratings/287?movie_id=32476&rating_value=1" method put
    // "/ratings?movie_id=3228&rating_value=5" method post
    $movie_rating.find('.rating a').each( function(index) {
      var rating_id = data.id;
      // $(this).data('rating_id', rating_id);
      var movie_id = $(this).data('movie_id');

      var rating_value = $(this).data('rating_value');

      var new_href = '/ratings/' + rating_id + '?movie_id=' + movie_id + '&rating_value=' + rating_value;
      $(this).attr('href', new_href);
      
    });
    $movie_rating.find('.rating').find('a').attr('data-method', 'put');

    debugger
    hollow_stars(this);
    fill_stars_upto_rating(this);


  }).on("ajax:error", function (e, xhr, status, error) {
  
    console.log('AJAX ERROR!!!!');
    var $movie_rating = $(this).closest('div.ratings-movie');
    var title = $movie_rating.find('div.title');
    title.append('<p>Aleady rated that value.</p>');
    title.find('p').fadeOut(500);


  }).mouseover(function (e) {
    hollow_stars(this);
    fill_stars(this);
  }).mouseout(function (e) {
    hollow_stars(this);
    fill_stars_upto_rating(this);
  });


  updateStars_forAll(); //fill in star values on page load

});