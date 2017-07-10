$(document).ready(function(){
	$('.print-report').on('click', function(){
		var printContents = document.getElementsByClassName('printable-section')[0].innerHTML;
		var originalContents = document.body.innerHTML;
    document.body.innerHTML = printContents;
    window.print();
    document.body.innerHTML = originalContents;
	});
});
