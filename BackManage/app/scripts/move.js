function move() {
	var n = 0;
    var m = 100;
    document.getElementById("second").style.display = "block";
    moveTimer = setInterval(function() {
      n--;
      m--;
      document.getElementById("first").style.left = n + '%';
      document.getElementById("second").style.left = m + '%';
      if (n == -100 || m == 0) {
        clearInterval(moveTimer);
      } 
    }, 1);
}

function back() {
	var n = -100;
    var m = 0;
    backTimer = setInterval(function() {
      n++;
      m++;
      document.getElementById("first").style.left = n + '%';
      document.getElementById("second").style.left = m + '%';
      if (n == 0 || m == 100) {
      	document.getElementById("second").style.display = "none";
        clearInterval(backTimer);
      } 
    }, 1);
}