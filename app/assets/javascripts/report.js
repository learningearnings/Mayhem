function printReport(){
  var printContents = document.getElementsByClassName('report')[0].innerHTML;
  var originalContents = document.body.innerHTML;
  document.body.innerHTML = printContents;
  window.print();
  document.body.innerHTML = originalContents;
}
