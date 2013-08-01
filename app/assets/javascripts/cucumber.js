$(function() {

  var removeSearchBar = function(){
    $('#search').hide();
  }
  
  if (window.location.pathname === '/users/edit'){
    removeSearchBar();
  }
  
});
