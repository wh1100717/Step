tag = null
$ ->
    garbage = ($ "#garbage")[0]
    tags = ($ ".tags")
    
    for i in [0...tags.length]
        tags[i].ondragstart = (ev) ->
            ev.dataTransfer.setData "text" , ev.target.innerHTML
            tag = ev.target;
            garbage.style.borderStyle = "solid";
            garbage.style.borderColor = "#66afe9";
            garbage.style.boxShadow = "inset 0 1px 1px rgba(0,0,0,.075),0 0 8px rgba(102,175,233,.6)";
            console.log("haha")
        tags[i].ondragend = (ev) ->
            tag = null;
            garbage.style.borderStyle = "dotted";
            garbage.style.borderColor = "#ccc";
            garbage.style.boxShadow = "none";
    garbage.ondragenter = (ev) ->
        ev.preventDefault()
    garbage.ondragover = (ev) ->
        ev.preventDefault()
    garbage.ondragleave = (ev) ->
        ev.preventDefault()
    garbage.ondrop = (ev) ->
        if tag 
            tag.parentNode.removeChild tag 
            ev.preventDefault()
addTag = ->
        p = $ ".tag"
        c = document.createElement "span"
        c.className = "btn btn-info btn-xs tags"
        c.title = "拖拽我"
        c.draggable = "true"
        c.innerHTML = (document.getElementById "addTag").value
        c.style.marginRight = "5px"
        p[0].appendChild c
        c.ondragstart = (ev) ->
            ev.dataTransfer.setData "text" , ev.target.innerHTML
            tag = ev.target
        c.ondragend = (ev) ->
            tag = null
    console.log()

