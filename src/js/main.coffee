launch = ()->

	#load in the data all exotics... or just save the hashes locally
	heavy =[3191797830,3191797831,3705198528,1274330687,1274330686]
	primary =[119482464,119482466,2809229973,119482465,346443849,3164616407,3164616405,3164616404,135862170,135862171,3490486524,3490486525,1389842217,2681212685]
	special =[346443851,346443850,1389842216,3118679308,3118679309]
	head =[144553854,2994845057,2771018501,94883184,2994845058,2994845059,144553855,2771018502,144553853,3455371673,2771018500,3577254054]
	arms =[2927156752,4146057409,4132383826,2591213943,2335332317,78421062]
	chest =[499191786,2272644374,1398023011,499191787,287395896,2272644375,1398023010]
	legs =[104781337,921478195]

	console.log "elloo"

	
	#pick some random exotics

	#load the data -- http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/4007228882/
	itemPath = "http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{heavy[0]}/"
	loadItemData = {}

	# loadItemData = $.getJSON itemPath, (itemData)->
	# 	console.log itemData
	

	# $.when(loadItemData).done dataLoaded

	#load the images

	#drop them
	console.log

	window.imgPath = ""

	$(".loot").click ()->
		$(this).toggleClass("reward")

	loadItemData = $.getJSON "http://query.yahooapis.com/v1/public/yql",
		{
		q: "select * from json where url=\"http://www.bungie.net/platform/Destiny/Manifest/InventoryItem/#{heavy[0]}/?fmt=JSON\"",
		format: "json"
		},
		(data)->		
			if (data.query.results)
				console.log "something"
				# do something with
				console.log data.query.results.json.Response.data.inventoryItem
				window.imgPath = "http://www.bungie.net" + data.query.results.json.Response.data.inventoryItem.icon
				# data.query.results.json.name
				# data.query.results.json.location
			else
				#nothing
				console.log "nothing"

	loadItemData.fail ()->
		console.error "loadItemData failed."

	$.when(loadItemData).done dataLoaded

dataLoaded = ()->
	console.info "data loaded."
	$(".loot .item").append("""<img src="#{window.imgPath}" />""")

$ ->
	launch()