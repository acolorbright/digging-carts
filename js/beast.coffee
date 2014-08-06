$ ->

	dataObject = {}
	player = {}

	hoverSound = new Howl {
		urls: ['sound/CLICK.mp3', 'sound/CLICK.ogg']
		volume: 0.5
	}

	clickSound = new Howl {
		urls: ['sound/EXIT.mp3', 'sound/EXIT.ogg']
		volume: 0.7
	}

	getData = ->
		$.ajax 'data/data.json',
			type: 'GET'
			error: (jqXHR, textStatus, errorThrown) ->
				console.log "AJAX Error: #{textStatus}"
			success: (data, textStatus, jqXHR) ->
				dataObject = data
				init()
	
	init = ->
		setupYouTube()
		setupBinds()
		addComposers()
		
		
	setupYouTube = ->
		tag = document.createElement('script')
		tag.src = "https://www.youtube.com/iframe_api"
		firstScriptTag = document.getElementsByTagName('script')[0]
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)


	window.onYouTubeIframeAPIReady = ->
		player = new YT.Player 'player',
			height: '390'
			width: '640'
			videoId: 'FuLTIi7CyOk'
			events: {
				"onReady": onPlayerReady
			}
			playerVars: {
				modestbranding: true
				controls: 0
				showinfo: 0
			}

	onPlayerReady = (event) ->
		resizeVid()
		

	setupBinds = ->
		console.log dataObject
		$('nav').bind 'mouseenter', ->
			$(@).transition
				left: 0
			, 200

		$('a').bind 'click', ->
			clickSound.play()
		
		$('a').bind 'mouseenter', ->
			hoverSound.play()

		$('nav').bind 'mouseleave', ->
			$(@).transition
				left: '-100px'
			, 200
		
		$('a.episode').bind 'click', ->
			order = $(@).data 'order'
			changeVideo(order)

		$('.composer-title').bind 'click', ->
			$(@).parent().find('.composer-nav').slideToggle()
		
		$('a.composer').bind 'click', ->
			$(@).find('.composer-data').slideToggle()
			$(@).find('li').toggleClass 'active'

		$('a.scroll').bind 'click', (event) ->
			link = $(@)
			smoothScroll(event, link)
			
			
		

	changeVideo = (order) ->
		video = dataObject.videos
		video = video[order]
		player.cueVideoById(video.id)

		$('.videos h2').empty().text video.title
		$('.videos p.body').empty().text video.body
		$('.videos p.body').slideDown()

	addComposers = (order,item) ->
		composers = $('.composer-nav ul li')
		composers.each (index) ->
			t = $(@)
			#account for zero indexing
			person = dataObject.composers[index + 1]
			name = person.name
			t.text(name)
			img = "img/#{person.image}"
			composerData = "<div class='composer-data'><img src='#{img}'/><p>#{person.bio}</p></div>"
			t.append composerData



	resizeVid = ->
		winWidth = $(window).width()
		vidWidth = winWidth / 1.5
		ogWidth = $('#player').attr('width')
		ogHeight = $('#player').attr('height')
		ratio = ogWidth / ogHeight

		$('#player').attr('width', vidWidth)
		$('#player').attr('height', vidWidth / ratio)

		diff = winWidth - vidWidth
		margin = diff / 2
		$('#player').css
			marginLeft: margin

	smoothScroll = (event, link) ->
		event.preventDefault()
		scrollTo = link.attr 'href'

		location = $("#{scrollTo}").offset().top

		console.log location

		if link.hasClass "active"
			return
		else
			$('nav ul a').each ->
				$(@).removeClass "active"

			link.addClass "active"
			

			$('.content').animate
				scrollTop: location
			, 300


	getData()


	
		
	