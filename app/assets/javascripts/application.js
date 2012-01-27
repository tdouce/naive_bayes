// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(function(){


  $('#new_sample').submit(function(){
    if ( $('#sample_weight').val() > 400 || $('#sample_height').val() > 7 || $('#sample_foot_size').val() > 15 )
      {
        var confirm_popup = confirm("Are you sure none of your numbers of too big? 'Cancel' to change number 'OK' to continue")
        if ( confirm_popup != true )
          return false
      };
  });




 });
