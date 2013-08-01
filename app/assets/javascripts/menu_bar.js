$(function() {

  $('#brand').addClass('slideDown');
  $('.nav').addClass('slideDown');
  $('#logo').addClass('floating');

  $('.pure-input-1-2').focus(function() {
    $('.pure-input-1-2').css('border','1px solid green');
    $(this).animate({width:'60%'}, 1000);
  });

  var path = location.pathname; 
  path = path.substring(path.lastIndexOf('/') - 5); //will return index.html
  if (path === "/ratings"){
    $('ul li #rate').parent().addClass('selected');
  }
  else {
    $('.navbar ul li a[href$="' + path + '"]').addClass('selected');
  }

});