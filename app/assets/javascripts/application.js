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

   var check_ids = ['sample_weight','sample_height','sample_foot_size']

   // for(var i in arr) {
   //   var value = arr[i];
   //   alert(i =") "+ value);
   // }

  $('#new_sample').submit(function(){
    if ( $('#sample_weight').val() > 400 || $('#sample_height').val() > 7 || $('#sample_foot_size').val() > 15 )
      {
        var confirm_popup = confirm("Some of numbers are really large? 'Cancel' to edit your numbers and 'OK' to continue with submission.")
        if ( confirm_popup != true )
          return false
      };
  });




 });
