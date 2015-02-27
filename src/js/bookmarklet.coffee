#load in howler
#load in main
#load in jquery
baseurl = "http://localhost:8000/"
loadjscssfile = (filename, filetype)->
	if filetype=="js"
		fileref=document.createElement 'script'
		fileref.setAttribute "type","text/javascript"
		fileref.setAttribute "src", filename
	else if filetype=="css"
		fileref=document.createElement "link"
		fileref.setAttribute "rel", "stylesheet"
		fileref.setAttribute "type", "text/css"
		fileref.setAttribute "href", filename
	if typeof fileref!="undefined"
		document.getElementsByTagName("head")[0].appendChild(fileref)

console.log "bookmarlet"

loadjscssfile baseurl + "js/howler.min.js", "js"
loadjscssfile baseurl + "js/main.js", "js"
loadjscssfile "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js", "js"