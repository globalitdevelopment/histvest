jQuery(document).ready ->
  
  if $("#textfield").size() > 0
    $("#textfield").autocomplete
      source: "/search.json"
      minLength: 2
      select: (e, ui)-> window.location = ui.item.url
      response: (e, ui)-> $("#textfield").removeClass 'ui-autocomplete-loading'
      search: (e, ui)-> $("#textfield").addClass 'ui-autocomplete-loading'
    .data("ui-autocomplete")._renderItem = (ul, item)->
      $("<li />")
        .data "item.autocomplete", item
        .append "<a href='#{item.url}'><img src='#{item.avatar_path}' /><span style='font-size:18px;line-height:7px;'>#{item.value}</span></a>"
        .appendTo ul 