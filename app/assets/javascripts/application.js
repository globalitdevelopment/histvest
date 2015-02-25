// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery/jquery
//= require jquery-ujs/rails
//= require jquery-ui
//= require jquery/jconfirm
//= require bootstrap
//= require bootbox
//= require fancybox
//= require underscore
//= require backbone
//= require backbone_rails_sync
//= require backbone_datalink
//= require backbone/histvest
//= stub wysiwyg
//= require_tree .


$(document).ready(function() {
  // var lnth = jQuery('div.nav').children('ul').children('li').length;
  // alert(lnth);
  // $('div.nav').css('padding-right',lnth+'px');

  $('#check_all').click (function () 
  {  
    var checkedStatus = this.checked;              
    $('.data-table tbody tr').find('td:first :checkbox').each(function ()
      {    
       $(this).prop('checked', checkedStatus);
      });
  }); 
  
});

function remove_fields(link) {
  //alert($(link).prev("input[type=hidden]").val("1");)
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}


jQuery(function() {
  if ($('.pagination').length) {
    $('#results').scroll(function() {
      var url;
      url = $('.pagination .next_page').attr('href');        
      if (url && $('#results').scrollTop()){         
        $('.pagination').text("More...");
        $.ajax({
          url: url,
          type: "GET",            
          processData: false,
          contentType: false,
          beforeSend: function(xhr, settings) {
            xhr.setRequestHeader('accept', '*/*;q=0.5, ' + settings.accepts.script);
          },
          success: function(m_data){   
          }
        })
      }
    });
    $('#results').scroll();
  }
});

