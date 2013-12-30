class RunningMap

  constructor: ->
    @map = L.mapbox.map 'map', 'benwatts.gl9fek8p'
    @map.setView([45.42249176479468, -75.69779634475708], 14);

    jQuery.ajax
      url: 'data/running-data.json'
      success: @mapLoadSuccess
      complete: @mapLoaded
      dataType: 'json'

  mapLoadSuccess: (data, textStatus) =>
    #console.log data

    for activity in data.activities
      m = moment(activity.features[0].properties.time)
      activityDate = m.format("MM-DD-YYYY")
      feature = L.geoJson(activity, { onEachFeature: @onEachFeature} ).addTo(@map)

  onEachFeature: (feature, layer) ->
    console.log feature


  mapLoadError: (jqXHR, textStatus, errorThrown) ->
    console.log errorThrown

  mapLoaded: (jqXHR, textStatus) ->
    console.log 'mapLoaded: ' + textStatus

new RunningMap()
