
launch = ()->
	# console.log("launch")
	window.baseurl = "http://designergroupies.com/lootdrop/"
	loadDependencies()
	
	snd.test()
	snd.load window.baseurl + "lootTest.mp4"

	#load in the data all exotics... or just save the hashes locally
	heavy =[3191797830,3191797831,3705198528,1274330687,1274330686]
	primary =[119482464,119482466,2809229973,119482465,346443849,3164616407,3164616405,3164616404,135862170,135862171,3490486524,3490486525,1389842217,2681212685]
	special =[346443851,346443850,1389842216,3118679308,3118679309]
	head =[144553854,2994845057,2771018501,94883184,2994845058,2994845059,144553855,2771018502,144553853,3455371673,2771018500,3577254054]
	arms =[2927156752,4146057409,4132383826,2591213943,2335332317,78421062]
	chest =[499191786,2272644374,1398023011,499191787,287395896,2272644375,1398023010]
	legs =[104781337,921478195]
	window.categories = [heavy, primary, special, head, arms, chest, legs]

	# console.log "dropping"

	
	#pick some random exotics

	#load the data -- http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/4007228882/
	# itemPath = "http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{heavy[0]}/"
	
	# window.dropSound = new Howl({
	# 					urls:['lootTest.mp4'], 
	# 					sprite:{chunk:[0,1500]}
	# 					})


	
	loadDrop();
reset = ()->
	#reset all the values

loadDependencies = ()->
	cssId = "dropCss"
	if !document.getElementById(cssId)
		head = document.getElementsByTagName("head")[0]
		link = document.createElement("link")
		link.id = cssId
		link.rel = "stylesheet"
		link.type = "text/css";
		link.href = window.baseurl + "css/loot.css"
		link.media = "all";
		head.appendChild(link);

loadDrop = ()->
	if !document.getElementById("loot-container")
		container = document.createElement("div")
		container.id = "loot-container"
		document.body.appendChild(container);

	items = []
	window.imgPaths = []
	#choose number of items to drop
	window.dropCount = Math.ceil(Math.random()*4)
	for[0...window.dropCount]
		#pick a random rarity?

		#pick a random category
		category = window.categories[Math.floor(Math.random()*window.categories.length)]
		#pick a random item
		# items.push(loadItem(category[Math.floor(Math.random()*category.length)]))

		loadItemData category[Math.floor(Math.random()*category.length)]

	
	# $.when.apply(this, items).done dataLoaded

drop = ()->
	console.log "drop"
	
	t = 300
	for item, index in window.imgPaths
		# itemE = $(itemTemplate)
		itemE = document.createElement("div")
		itemE.classList.add "loot"
		imgPath = window.imgPaths[index]
		itemE.innerHTML = """
			<div class="item">
				<img src="#{imgPath}" />
			</div>
			<div class="sparkles">
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
				<div class="sparkle"></div>
			</div>
	"""
		document.getElementById("loot-container").appendChild itemE

		do (itemE)->
			after t, ()=>
				itemE.classList.add "reward"
				# window.dropSound.play('chunk')
				snd.play()
		t += 120

after = (t, f) ->
	setTimeout f, t

# dataLoaded = ()->
# 	console.info "data loaded."
# 	drop()
	# $(".loot").toggleClass("reward")
	

# loadItem = (hash)->
# 	return $.getJSON "http://query.yahooapis.com/v1/public/yql",
# 		{
# 		q: "select * from json where url=\"http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{hash}/?fmt=JSON\"",
# 		format: "json"
# 		},
# 		(data)->		
# 			if (data.query.results)
# 				# console.log "something"
# 				# do something with
# 				console.log data.query.results.json.Response.data.inventoryItem
# 				window.imgPaths.push("http://www.bungie.net" + data.query.results.json.Response.data.inventoryItem.icon)
# 				# data.query.results.json.name

# 				# data.query.results.json.location
# 			else
# 				#nothing
# 				console.log "nothing"



loadItemData = (hash)->
	#http://query.yahooapis.com/v1/public/yql?q=select+*+from+json+where+url%3D%22http%3A%2F%2Fwww.bungie.net%2Fplatform%2FDestiny%2FManifest%2FInventoryItem%2F135862170%2F%3Ffmt%3DJSON%22&format=json
	#http://query.yahooapis.com/v1/public/yql?q%3Dselect%20*%20from%20json%20whe…2FManifest%2FInventoryItem%2F3164616405%2F%3Ffmt%3DJSON%22%26format%3Djson

	request = new XMLHttpRequest();
	do (request)->
		url = "http://query.yahooapis.com/v1/public/yql"
		query = "?q=" + encodeURIComponent("select * from json where url=\"http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{hash}/?fmt=JSON\"") + "&format=json"
		# console.log url+query
		request.open('GET', url+query, true);
		request.onload = ()->
			if (request.status >= 200 && request.status < 400)
				# console.log "success", JSON.parse(request.responseText)
				# var data = JSON.parse(request.responseText);
				window.imgPaths.push("http://www.bungie.net" + JSON.parse(request.responseText).query.results.json.Response.data.inventoryItem.icon)
				if window.imgPaths.length >= window.dropCount
					drop()
			else
				# console.error "load failed"

		request.onerror = ()->
			console.log "request.onerror"

		request.send()

class SoundFX
#audio junk

	constructor:()->
		@soundBuffer = null
		@loaded=false
		# // Fix up prefixing
		window.AudioContext = window.AudioContext || window.webkitAudioContext
		@context = new AudioContext()
		console.log @context

	load:(@url)->
		request = new XMLHttpRequest()
		request.open('GET', @url, true);
		request.responseType = 'arraybuffer';

		# function loadDogSound(url) {
		# var request = new XMLHttpRequest();
		# request.open('GET', url, true);
		# request.responseType = 'arraybuffer';

		# // Decode asynchronously
		# do(request)->
		request.onload = ()=>
				@context.decodeAudioData request.response, (buffer)=>
						@soundBuffer = buffer
						@loaded=true
						console.log "loaded sound", @
						# @play()
			request.send()

	play:()->
		if @loaded == false
			return
		# console.log "play @soundBuffer", @soundBuffer
		source = @context.createBufferSource()
		source.buffer = @soundBuffer
		source.connect(@context.destination)
		source.start(0)

	test:()->
		# console.log 'ello'
		try
			# // Fix up for prefixing
			window.AudioContext = window.AudioContext||window.webkitAudioContext;
			context = new AudioContext();
			# console.log 'try'
		catch error
			# console.log 'catch'
			console.log "error setting up sound"


console.log("main.js")
# $ ->
# 	launch()
snd = new SoundFX()
launch()

# snd.play()

#load main
#load jquery