function printReport(){
  var printBody = document.getElementsByClassName('report')[0].innerHTML;
  var printHeader = document.getElementsByTagName('h1')[0].innerHTML;
  var printContents = '<h1>' + printHeader + '</h1>' + printBody;
  var originalHeader = document.head.innerHTML;
  var originalContents = document.body.innerHTML;
  document.body.innerHTML = printContents;
  window.print();
  document.body.innerHTML = originalContents;
  document.head.innerHTML = originalHeader;
}
