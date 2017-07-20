function printReport(){
  var printBody = document.getElementsByClassName('report')[0].innerHTML;
  var printHeader = document.getElementsByTagName('h1')[0].innerHTML;
  var printContents = '<h1>' + printHeader + '</h1>' + printBody;
  var originalContents = document.body.innerHTML;
  w = window.open();
  w.document.body.innerHTML = printContents;
  w.print();
  w.close();
}
