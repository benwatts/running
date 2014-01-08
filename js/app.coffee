class RunningMap

  constructor: ->
    if !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1")
      $('html').addClass 'no-svg-support'
      console.log "GL"

    @map = L.mapbox.map 'map'
    @map.addLayer L.mapbox.tileLayer 'benwatts.gl9fek8p', { detectRetina: true }
    @map.setView([45.42185921726068, -75.71292400360107], 13);
    @map.on 'layeradd', (e) ->
      if e.layer.hasOwnProperty('feature')
        feature = e.layer.feature
        activityDate = moment(feature.properties.time).format('MM-YYYY')
        shapePath = e.layer._container.firstChild
        shapePath.classList.add "date-#{activityDate}"

    jQuery.ajax
      url: 'data/running-data.json'
      success: @mapLoadSuccess
      complete: @mapLoaded
      dataType: 'json'

    $('.odo').each ->
      od = new Odometer
        el: $(@)[0]
        value: 0
        format: "(,ddd).dd"
        theme: "default"
      od.update $(@).attr('data-val')

    $('.date-toggle').on 'click', (e) ->
      $('.' + $(@).attr('data-paths')).toggle()
      $(@).toggleClass('is-disabled')

    totalDistance = 1505
    $('.bar').each () ->
      distance = $(@).attr('data-val');
      barHeight = (distance/totalDistance)*700
      $(@).css('height', barHeight+'%')
      $(@).parents('li').append("<p class='date-toggle-distance'>#{distance} km</p>")

    return @map

  gratuitousAnimation: -> # because.
    $('path').each (i, e) =>
      animationLength = @randomInt(10000,5000)
      $p = $(e)
      pLength = $p[0].getTotalLength()

      $p.attr 'stroke-dasharray', "#{pLength} #{pLength}"
      $p.attr 'stroke-dashoffset', "#{pLength}"

      $p.css '-webkit-animation-duration', "#{animationLength}ms"
      $p.css '-moz-animation-duration', "#{animationLength}ms"
      $p.css 'animation-duration', "#{animationLength}ms"

      $p.on 'animationend MSAnimationEnd webkitAnimationEnd', ->
        $(@).attr 'stroke-dashoffset', "0" #... I'm animating to 0, so I don't know why I need to do this. ffs.


  randomInt: (max, min) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  mapLoadSuccess: (data, textStatus) =>
    for activity in data.activities
      feature = L.geoJson(activity, {clickable: false}).addTo(@map)
    $('#map-loading').fadeOut(300)
    @gratuitousAnimation()

  mapLoadError: (jqXHR, textStatus, e) ->
    console.log e

  mapLoaded: (jqXHR, textStatus) ->
    console.log 'mapLoaded: ' + textStatus

window.bestMap = new RunningMap()
