class RunningMap

  constructor: ->
    #map = L.mapbox.map 'map', 'benwatts.gl9fek8p'
    #map.setView([45.42, -75.6], 15);

    jQuery.ajax
      url: 'data/running-data.json'
      success: @mapLoadSuccess
      complete: @mapLoaded
      dataType: 'json'

  mapLoadSuccess: (data, textStatus) ->
    console.log data

  mapLoadError: (jqXHR, textStatus, errorThrown) ->
    console.log errorThrown

  mapLoaded: (jqXHR, textStatus) ->
    console.log 'mapLoaded: ' + textStatus

new RunningMap()
