#//= require jquery/jconfirm

myCustomConfirmBox = (message, callback) ->
  bootbox.dialog
    message: message
    buttons:
      success:
        label: "OK"
        className: "btn-danger"
        callback: ->
          callback()  if typeof callback is "function"

      danger:
        label: "Avbryte"
        className: "btn-default"


$.rails.allowAction = (element) ->
  message = element.data("confirm")
  return true  unless message

  answer = false
  callback = undefined

  if $.rails.fire(element, "confirm")
    myCustomConfirmBox message, ->
      callback = $.rails.fire(element, "confirm:complete", [answer])
      if callback
        oldAllowAction = $.rails.allowAction
        $.rails.allowAction = ->
          true

        element.trigger "click"
        $.rails.allowAction = oldAllowAction

  false
