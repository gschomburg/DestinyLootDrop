launch = ()->
	window.baseurl = "http://localhost:8000/"
	loadDependencies()
	#load in the data all exotics... or just save the hashes locally
	heavy =[3191797830,3191797831,3705198528,1274330687,1274330686]
	primary =[119482464,119482466,2809229973,119482465,346443849,3164616407,3164616405,3164616404,135862170,135862171,3490486524,3490486525,1389842217,2681212685]
	special =[346443851,346443850,1389842216,3118679308,3118679309]
	head =[144553854,2994845057,2771018501,94883184,2994845058,2994845059,144553855,2771018502,144553853,3455371673,2771018500,3577254054]
	arms =[2927156752,4146057409,4132383826,2591213943,2335332317,78421062]
	chest =[499191786,2272644374,1398023011,499191787,287395896,2272644375,1398023010]
	legs =[104781337,921478195]
	window.categories = [heavy, primary, special, head, arms, chest, legs]

	console.log "dropping"

	
	#pick some random exotics

	#load the data -- http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/4007228882/
	# itemPath = "http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{heavy[0]}/"
	
	# window.dropSound = new Howl({
	# 					urls:['lootTest.mp4'], 
	# 					sprite:{chunk:[0,1500]}
	# 					})
	
	loadDrop();

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
	if $("#loot-container").length < 1
		$("body").prepend("""<div id="loot-container"></div>""")

	items = []

	#choose number of items to drop
	for[0...Math.random()*4]
		#pick a random rarity?

		#pick a random category
		category = window.categories[Math.floor(Math.random()*window.categories.length)]
		#pick a random item
		items.push(loadItem(category[Math.floor(Math.random()*category.length)]))

	window.imgPaths = []
	$.when.apply(this, items).done dataLoaded

drop = ()->
	console.log "drop"
	itemTemplate = """
	<div class="loot">
			<div class="item"></div>
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
		</div>
	"""
	
	t = 300
	for item, index in window.imgPaths
		itemE = $(itemTemplate)
		$(".item",itemE).append("""<img src="#{window.imgPaths[index]}" />""")
		# console.log item
		$("#loot-container").append(itemE)
		itemE.click ()->
			$(this).toggleClass("reward")
			# window.dropSound.play()

		do (itemE)->
			after t, ()=>
				console.log $(this)
				itemE.toggleClass("reward")
				# window.dropSound.play()
				# window.dropSound.play('chunk')
		t += 120




after = (t, f) ->
	setTimeout f, t

dataLoaded = ()->
	console.info "data loaded."
	drop()
	# $(".loot").toggleClass("reward")
	

loadItem = (hash)->
	return $.getJSON "http://query.yahooapis.com/v1/public/yql",
		{
		q: "select * from json where url=\"http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{hash}/?fmt=JSON\"",
		format: "json"
		},
		(data)->		
			if (data.query.results)
				# console.log "something"
				# do something with
				console.log data.query.results.json.Response.data.inventoryItem
				window.imgPaths.push("http://www.bungie.net" + data.query.results.json.Response.data.inventoryItem.icon)
				# data.query.results.json.name
				# data.query.results.json.location
			else
				#nothing
				console.log "nothing"

$ ->
	launch()