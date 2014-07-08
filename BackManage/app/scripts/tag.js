window.onload = function() {
	var garbage = document.getElementById("garbage");
	var tags = document.getElementsByClassName("tags");
	var tag = null;
	for(var i = 0; i < tags.length; i++) {
		tags[i].ondragstart = function(ev) {
	        ev.dataTransfer.setData("text", ev.target.innerHTML);
	        tag = ev.target;
	        garbage.style.borderStyle = "solid";
	        garbage.style.borderColor = "#66afe9";
	        garbage.style.boxShadow = "inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)";
	        return true;
		};
		tags[i].ondragend = function(ev) {
	        tag = null;
	        garbage.style.borderStyle = "dotted";
	        garbage.style.borderColor = "#ccc";
	        garbage.style.boxShadow = "none";
	        return false;
		};
	};
	garbage.ondragenter = function(ev) {
		ev.preventDefault();
		return true;
	};
	garbage.ondragover = function(ev) {
		ev.preventDefault();
		return true;
	};
	garbage.ondragleave = function(ev) {
		ev.preventDefault();
		return true;
	};
	garbage.ondrop = function(ev) {
		if(tag) {
	        tag.parentNode.removeChild(tag);
	    }
	    ev.preventDefault();
	    return false;
	};
};

function addTag() {
	var p = document.getElementsByClassName("tag")[0];
	var c = document.createElement("span");
	c.className = "btn btn-info btn-xs tags";
	c.title = "拖拽我";
	c.draggable = "true";
	c.innerHTML = document.getElementById("addTag").value;
	p.appendChild(c);
}