class RunningMap

  constructor: ->
    if !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1")
      $('html').addClass 'no-svg-support'
      console.log "GL"

    @map = L.mapbox.map 'map','benwatts.gl9fek8p'
    @map.setView([45.42249176479468, -75.69779634475708], 14);
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

    $('.odo').each () ->
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

  mapLoadSuccess: (data, textStatus) =>
    for activity in data.activities
      feature = L.geoJson(activity, {clickable: false}).addTo(@map)
    $('#map-loading').fadeOut(300)

  mapLoadError: (jqXHR, textStatus, errorThrown) ->
    console.log errorThrown

  mapLoaded: (jqXHR, textStatus) ->
    console.log 'mapLoaded: ' + textStatus

window.bestMap = new RunningMap()
