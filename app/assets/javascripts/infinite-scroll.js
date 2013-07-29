function checkScroll(){
  if (nearBottomOfPage()){
    
  }
}

$('documnet').ready(function(){
  intervalID = setInterval(checkScroll, 250);
});
