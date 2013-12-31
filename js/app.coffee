class RunningMap

  @totals
    'months':
      'jan': 87
      'feb': 115
      'mar': 153
      'apr': 211
      'may': 180
      'jun': 141
      'jul': 153
      'aug': 117
      'sep': 118
      'oct': 92
      'nov': 68
      'dec': 62

  constructor: ->
    if !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1")
      $('html').addClass 'no-svg-support'
      return false

    @map = L.mapbox.map 'map','benwatts.gl9fek8p'
    @map.setView([45.42249176479468, -75.69779634475708], 14);
    @map.on 'layeradd', (e) ->
      if e.layer.hasOwnProperty('feature')
        feature = e.layer.feature
        activityDate = moment(feature.properties.time).format('MM-YYYY')
        shapePath = e.layer._container.firstChild
        shapePath.classList.add "date-#{activityDate}"

    $('.date-toggle-btn').on 'click', (e) ->
      $('.' + $(this).attr('data-paths')).toggle()
      $(this).toggleClass('is-disabled')

    jQuery.ajax
      url: 'data/running-data.json'
      success: @mapLoadSuccess
      complete: @mapLoaded
      dataType: 'json'

    return @map

  mapLoadSuccess: (data, textStatus) =>
    for activity in data.activities
      feature = L.geoJson(activity, {clickable: false}).addTo(@map)

  mapLoadError: (jqXHR, textStatus, errorThrown) ->
    console.log errorThrown

  mapLoaded: (jqXHR, textStatus) ->
    console.log 'mapLoaded: ' + textStatus

window.bestMap = new RunningMap()
