// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require underscore-min.js
//= require_tree .

$(function(){

  // Provides warnings for forms if user inputs values that are unusually large or small.
  function warnings(){

    // Maximum and minimum weights used to generate warnings
    var weight_min    = 50;
    var weight_max    = 400;
    var height_ft_min = 4;
    var height_ft_max = 7;
    var height_in_min = 0;
    var height_in_max = 11;
    var foot_size_min = 4;
    var foot_size_max = 17;

     // Used to check the input values on form submission to make sure that a user did not
     // accidently type in an 'extreme' value. [ input id, minimum value, maximum value ]
     var check_ids = [
                      [ 'sample_weight',        weight_min,     weight_max],
                      [ 'sample_height_ft',     height_ft_min,  height_ft_max ],
                      [ 'sample_height_in',     height_in_min,  height_in_max ],
                      [ 'sample_foot_size',     foot_size_min,  foot_size_max  ],
                      [ 'individual_weight',    weight_min,     weight_max ],
                      [ 'individual_height_ft', height_ft_min,  height_ft_max ],
                      [ 'individual_height_in', height_in_min,  height_in_max ],
                      [ 'individual_foot_size', foot_size_min,  foot_size_max  ]
                     ];

    // Remove any previous warnings that may exist
    function remove_warnings(){
    
      // Remove any validation errors that might exist
      $('.error_explination').remove();

      // Clearn any previous ajax response
      $('#response').html('<p></p>');

      // Clear any previous extreme number warnings
      $('*').removeClass('extreme_number');
    };

    // On click clear each input value, remove any previous result, and
    // remove any classes they may exist from previous submissions
    $("#clear_button").click(function(){

      // Remove any previous validations or warnings
      remove_warnings();

      // Clear all values
      _.each( check_ids, function( id ){ $('#' + id).val(''); });

    });

    // On form submission check to see if any of the input values are extreme
    // using the ids and values from 'var check_ids'.  If there are extreme values
    // then highlit those input fields and prompt a confirm box.
    $('#submit_sample').click(function(event){

      // Remove any previous validations or warnings
      remove_warnings();

      // Value used to see if the confirm alert should be presented
      var warning = false;

      // Loop over each input and check if input value is below min or above max
      _.each( check_ids, function( id ){ 
        if ( $('#' + id[0]).val() < id[1] || $('#' + id[0]).val() > id[2]  ) {

              // Set warning to true
              warning = true;

              // Add warning class
              $('#' + id[0]).addClass('extreme_number');
            };
      });
        
      // If any of the input values were 'extreme', then present a confirm box
      if ( warning == true ){

        var confirm_popup = confirm("Are you sure the values are correct? 'Cancel' to edit and 'OK' to continue with submission.");

        // If the user wants to edit the values then stop form submission
        if ( confirm_popup == false )
          { event.preventDefault(); }

        // If user does NOT want to edit form values then continue with submission and remove any warnings
        else 
          // Remove any previous validations or warnings
          { remove_warnings(); };
      };
     });
    };

  // Invoke warnings 
  warnings()

 });
