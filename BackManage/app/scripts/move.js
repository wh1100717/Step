function move() {
	document.getElementById("first").style.left = "-100%";
	document.getElementById("second").style.left = "0";
	document.getElementById("second").style.display = "block";
}

function back() {
	document.getElementById("first").style.left = "0";
	document.getElementById("second").style.left = "100%";
	document.getElementById("second").style.display = "none";
}