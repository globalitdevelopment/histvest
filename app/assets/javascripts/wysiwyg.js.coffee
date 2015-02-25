#= require froala-wysiwyg/froala_editor.min
#= require froala-wysiwyg/plugins/block_styles.min
#= require froala-wysiwyg/plugins/media_manager.min
#= require froala-wysiwyg/plugins/tables.min.js

$.Editable.DEFAULTS.key = 'KB17C10ddD-11F-10ftagC3D-17y=='

$(document).ready ->
	$('.tinymce').editable
  	inlineMode: false