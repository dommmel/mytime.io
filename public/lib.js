(function() {
function getAllElementsWithAttribute(attribute)
{
  var matchingElements = [];
  var allElements = document.getElementsByTagName('*');
  for (var i = 0, n = allElements.length; i < n; i++)
  {
    if (allElements[i].getAttribute(attribute))
    {
      // Element exists with attribute. Add to array.
      matchingElements.push(allElements[i]);
    }
  }
  return matchingElements;
}
function load(element) {
    var xmlhttp;
    if (window.XMLHttpRequest) {
        // code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    } else {
        // code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
          var date = new Date(xmlhttp.responseText);
          var TZ = "";
          try {
            // Get timezone. See http://stackoverflow.com/a/12496442
            var ds = date.toString();
            TZ = ds.indexOf('(') > -1 ?
            ds.match(/\([^\)]+\)/)[0].match(/[A-Z]/g).join('') :
            ds.match(/[A-Z]{3,4}/)[0];
            if (TZ == "GMT" && /(GMT\W*\d{4})/.test(ds)) TZ = RegExp.$1;
            TZ = " "+ TZ;
            // show tz
          } catch(e) { }
          element.innerHTML = date.toLocaleTimeString() + TZ;
        }
    }
    xmlhttp.open("GET", "http://mytime.io/" +  element.getAttribute("data-mytime"), true);
    xmlhttp.setRequestHeader('Accept', 'text/plain');
    xmlhttp.send();
}

var elems = getAllElementsWithAttribute("data-mytime")
for (index = 0; index < elems.length; ++index) {
    var what = elems[index].getAttribute("data-mytime");
    load(elems[index]);
}
})();

