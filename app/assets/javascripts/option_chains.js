//= require chartist/chartist.min.js

$(function(){
    var search_symbol;
    $('.earning_btn').on('click', function(){
        search_symbol = $('.earning_symbol_input').val();
        $.ajax({
            url: '/earning_reports/' + search_symbol,
            cache: false,
            success: function(html){
                console.log('im here');
                $('.recent_three_reports').html('');
                $('.recent_three_reports').append(html);
            }
        })
    });
});

$(function(){
    var current_btn = $('.current_pain_btn'),
        form = $('.current_pain_search_form');
    var current_pain_symbol = '',
        temp_input = '';

    var currentPainChart = function(){
        console.log("clicked");
        current_pain_symbol = $('.current_pain_symbol').val();
        $.ajax({
            url: '/current_pain/' + current_pain_symbol,
            cache: false,
            success: function(html){
                console.log('hi');
                $('.current_pain_row').html('');
                $('.current_pain_row').append(html);
            }
        });
    }

    form.on('click', current_btn, function(){
        console.log("what?");
        if(current_pain_symbol !== $('.current_pain_symbol').val()){
           currentPainChart(); 
        }    
    });
    
})