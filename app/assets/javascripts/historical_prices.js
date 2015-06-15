
$(function(){
	$('.ajax_next_btn').on('click', function(){
		$.ajax({
		           type: "GET",
		           contentType: "application/json; charset=utf-8",
		           url: '/next',
		           dataType: 'json',
		           success: function (data) {
		              console.log(data);
		              $('.aaa_box').append("hello");
		           },
		           error: function (result) {
		               error();
		           }
		});
	});
});