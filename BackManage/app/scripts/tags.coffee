window.onload = ->
	garbag = document.getElementById "garbag"
	tags = document.getElementsByClassName "tags"
	tag = null
	for i in tags
		i.ondragstart = (ev) ->
			ev.dataTransfer.setData "text",ev.target.innerHTML
			tag = ev.target
			garbage.style.borderStyle = "solid"
			garbage.style.borderColor = "#66afe9"
			garbage.style.boxShadow = "inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)"
			true
		i.ondragend = (ev) ->
			tag = null
			garbage.style.borderStyle = "dotted"
			garbage.style.borderColor = "#ccc"
			garbage.style.boxShadow = "none"
			false
	garbage.ondragenter = (ev) ->
		ev.preventDefault()
		true
	garbage.ondragover = (ev) ->
		ev.preventDefault()
		true
	garbage.ondragleave = (ev) ->
		ev.preventDefault()
		true
	garbage.ondrop = (ev) ->
		if tag then tag.parentNode.removeChild tag
		ev.preventDefault()
		false

addTag = ->
	p = document.getElementsByClassName "tag"
	c = document.createElement "span"
	tagV = document.getElementById "addTag"
	c.className = "btn btn-info btn-xs tags"
	c.title = "拖拽我"
	c.draggable = "true"
	c.innerHTML = tagV.value
	c.style.marginRight = "5px"
	p[0].appendChild c