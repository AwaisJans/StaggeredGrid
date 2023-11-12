

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWebView(),
    );
  }
}

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController? _webViewController;
  bool javascriptCanOpenWindowsAutomatically = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Example'),

      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: """
          <!DOCTYPE html>
<html lang="de">
   <head>
      <title>App Content</title>
      <meta charset="utf-8">
      <style> html{-webkit-text-size-adjust:100%}body *{font-family:-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,Ubuntu;font-size:16px;font-weight:400;line-height:1.3;background:transparent;box-sizing:border-box}body p{margin:1em 0;word-wrap:break-word;overflow-wrap:break-word;-webkit-hyphens:auto;-moz-hyphens:auto;hyphens:auto}body h2{font-size:1.2em;font-weight:700}body strong{font-weight:700}body a{color:#0571B1;word-wrap:break-word;overflow-wrap:break-word;hyphens:auto}body figure{margin:0;margin-top:70px}body figure.video{position:relative;padding-top:75%}body figure.video iframe{position:absolute;width:100%;height:100%;top:0;left:0}body figcaption{font-style:italic;font-size:calc(16px - 1px)}body .contentelement{margin-top:2em}body .contentelement:first-child{margin-top:0}body .contentbereichInfobox{position:relative;padding:.5em 1.5em;width:100%;margin-top:2em;background:#f2f2f2;border:1px solid #e2e2e2}body img{max-width:100%}body iframe{width:100%}body .frame-accordion .frame-title{display:block;position:relative;margin:2px 0 0 0;padding:.8em .5em .8em 26px;border:none;background:rgba(0,0,0,0);border-bottom:1.5px dotted #e2e2e2;transition:border 0ms linear 1000ms}body .frame-accordion .frame-title:before{content:"+";display:inline-block;font-style:normal;font-variant:normal;text-rendering:auto;font-weight:400;color:#0571B1;position:absolute;top:50%;transform:translateY(calc(-50% - 2px));left:0;font-size:26px;line-height:1}body .frame-accordion .frame-title.active{border-bottom:none;transition:border 0ms linear 0ms}body .frame-accordion .frame-title.active:before{content:"-"}body .frame-accordion .frame-title.active+.js-accordion-wrap{border-bottom:1px solid #e2e2e2;transition:max-height 1000ms ease-out,border-color 0ms linear 0ms}body .frame-accordion .frame-title button{display:block;width:100%;text-align:left;padding:.8em .5em .8em 0;border:none;position:relative}body .frame-accordion .frame-title button span{font-weight:600}body .frame-accordion .js-accordion-wrap{display:none;border-bottom:1px solid transparent;padding:1px;max-height:0;overflow:hidden;transition:max-height 1000ms ease-out,border-color 0ms linear 1000ms}body .icon_content{display:inline-block;width:16px;height:16px;margin-right:5px;background:no-repeat center}body .fa-phone{background-image:url("data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20512%20512%22%3E%3C!--!%20Font%20Awesome%20Pro%206.2.0%20by%20%40fontawesome%20-%20https%3A%2F%2Ffontawesome.com%20License%20-%20https%3A%2F%2Ffontawesome.com%2Flicense%20(Commercial%20License)%20Copyright%202022%20Fonticons%2C%20Inc.%20--%3E%3Cpath%20d%3D%22M164.9%2024.6c-7.7-18.6-28-28.5-47.4-23.2l-88%2024C12.1%2030.2%200%2046%200%2064C0%20311.4%20200.6%20512%20448%20512c18%200%2033.8-12.1%2038.6-29.5l24-88c5.3-19.4-4.6-39.7-23.2-47.4l-96-40c-16.3-6.8-35.2-2.1-46.3%2011.6L304.7%20368C234.3%20334.7%20177.3%20277.7%20144%20207.3L193.3%20167c13.7-11.2%2018.4-30%2011.6-46.3l-40-96z%22%2F%3E%3C%2Fsvg%3E")}body .fa-mobile{background-image:url("data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20384%20512%22%3E%3C!--!%20Font%20Awesome%20Pro%206.2.0%20by%20%40fontawesome%20-%20https%3A%2F%2Ffontawesome.com%20License%20-%20https%3A%2F%2Ffontawesome.com%2Flicense%20(Commercial%20License)%20Copyright%202022%20Fonticons%2C%20Inc.%20--%3E%3Cpath%20d%3D%22M16%2064C16%2028.7%2044.7%200%2080%200H304c35.3%200%2064%2028.7%2064%2064V448c0%2035.3-28.7%2064-64%2064H80c-35.3%200-64-28.7-64-64V64zM144%20448c0%208.8%207.2%2016%2016%2016h64c8.8%200%2016-7.2%2016-16s-7.2-16-16-16H160c-8.8%200-16%207.2-16%2016zM304%2064H80V384H304V64z%22%2F%3E%3C%2Fsvg%3E")}body .fa-fax{background-image:url("data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20512%20512%22%3E%3C!--!%20Font%20Awesome%20Pro%206.2.0%20by%20%40fontawesome%20-%20https%3A%2F%2Ffontawesome.com%20License%20-%20https%3A%2F%2Ffontawesome.com%2Flicense%20(Commercial%20License)%20Copyright%202022%20Fonticons%2C%20Inc.%20--%3E%3Cpath%20d%3D%22M128%2064v96h64V64H386.7L416%2093.3V160h64V93.3c0-17-6.7-33.3-18.7-45.3L432%2018.7C420%206.7%20403.7%200%20386.7%200H192c-35.3%200-64%2028.7-64%2064zM0%20160V480c0%2017.7%2014.3%2032%2032%2032H64c17.7%200%2032-14.3%2032-32V160c0-17.7-14.3-32-32-32H32c-17.7%200-32%2014.3-32%2032zm480%2032H128V480c0%2017.7%2014.3%2032%2032%2032H480c17.7%200%2032-14.3%2032-32V224c0-17.7-14.3-32-32-32zM256%20320c-17.7%200-32-14.3-32-32s14.3-32%2032-32s32%2014.3%2032%2032s-14.3%2032-32%2032zm160-32c0%2017.7-14.3%2032-32%2032s-32-14.3-32-32s14.3-32%2032-32s32%2014.3%2032%2032zM384%20448c-17.7%200-32-14.3-32-32s14.3-32%2032-32s32%2014.3%2032%2032s-14.3%2032-32%2032zm-96-32c0%2017.7-14.3%2032-32%2032s-32-14.3-32-32s14.3-32%2032-32s32%2014.3%2032%2032z%22%2F%3E%3C%2Fsvg%3E")} </style>
      <script> (function() { let HWPhonenumberReplace = { dialingCodeFallback: '+49', phonenumberClasses: ["phonenumber"], allowedParentClasses: ["phonenumber_wrap", "mobile_phone_wrap"] }; /** * Add the cols classes and create the inner menu views and adds events listeners * @private */ HWPhonenumberReplace.replacePhonenumbers = function() { /** @type {HTMLCollectionOf<Element>} */ let phonenumberElements = document.querySelectorAll('.' + this.phonenumberClasses.join(',.')); for (let i = 0; i < phonenumberElements.length; i++) { /** @type {HTMLElement} */ let thisPhonenumberElement = phonenumberElements[i]; /** @type {HTMLElement} */ let thisPhonenumberParent = phonenumberElements[i].parentElement; /** @type {HTMLElement} */ let thisPhonenumberContent = thisPhonenumberElement.innerText; /** @type {HTMLElement} */ let thisPhonenumberLink = ""; /*check if just numbers with optinal leading "+"*/ let validPhonenumber = new RegExp("^((\\+\\d{2}(?!0)|0(?!0)|00(?!0))( ?\\d+|( ?\\(0\\) ?\\d+)))|(112|110|116116|116117|19222|115|11861)"); let thisPhonenumberDialingCode = this.dialingCodeFallback; if(thisPhonenumberElement.getAttribute("data-code") != null) { thisPhonenumberDialingCode = thisPhonenumberElement.getAttribute("data-code"); } /** @type {HTMLElement} */ if (thisPhonenumberElement.getAttribute("data-dialing-code")) { thisPhonenumberDialingCode = thisPhonenumberElement.getAttribute("data-dialing-code"); } thisPhonenumberLink = thisPhonenumberContent.replace(/[\s-\/\\]|((\(\s*\d(?!d)\s*\))|[()])/gm, ''); if (!validPhonenumber.test(thisPhonenumberLink)) { console.error("Invalid: " + thisPhonenumberLink); continue; } if (thisPhonenumberLink.charAt(0) === "0") { if (thisPhonenumberLink.charAt(1) === "0") { thisPhonenumberLink = thisPhonenumberLink.replace(/^00/gm, "+"); } else { thisPhonenumberLink = thisPhonenumberLink.replace(/^0/gm, thisPhonenumberDialingCode); } } else { if (thisPhonenumberLink.charAt(0) === "+") { /*In this case we dont need to fix something*/ } else { if (['112', '110', '116116', '116117', '19222', '115', '11861'].includes(thisPhonenumberLink)) { console.log(thisPhonenumberLink); console.log(thisPhonenumberLink); } else { continue; } } } if (!this.checkParent(thisPhonenumberParent, this.allowedParentClasses)) { continue; } let thisPhonenumberInnerHTML = thisPhonenumberParent.innerHTML; let thisPhonenumberInnerHTMLNew = '<a href="tel:' + thisPhonenumberLink + '">' + thisPhonenumberInnerHTML + '</a>'; thisPhonenumberParent.innerHTML = thisPhonenumberInnerHTMLNew; } }; HWPhonenumberReplace.checkParent = function(element, classNames) { for(var k = 0; k < classNames.length; k++) { if(element.classList.contains(classNames[k])) { return true; } } return false; }; /* Slide-Blöcke */ window.addEventListener('load', function() { let accordionClasses = 'frame-accordion'; let titleClass = 'frame-title'; let contentClass = 'js-accordion-wrap'; let accordionElements = document.getElementsByClassName(accordionClasses); /*For IOS - height gets set at the webkit constant basic height of all non slideblock elements, including the default margin of the body*/ let allNonAccordionContent = document.getElementsByClassName('contentelement frame'); let baseContentHeight = parseInt(window.getComputedStyle(document.body).marginTop) + parseInt(window.getComputedStyle(document.body).marginBottom); for (let l = 0; l < allNonAccordionContent.length; l++) { if(!allNonAccordionContent[l].classList.contains(accordionClasses)) { baseContentHeight += allNonAccordionContent[l].scrollHeight; } } for (let i = 0; i < accordionElements.length; i++) { let thisAccordionElement = accordionElements[i]; let accordionTitle = thisAccordionElement.getElementsByClassName(titleClass)[0]; if (accordionTitle == null) { continue; } if (accordionTitle.classList.contains('is_slideblock')) { continue; } accordionTitle.classList.add('is_slideblock'); accordionTitle.innerHTML = '<button aria-expanded=\'false\' aria-controls=\'js-accordion-content_' + i + '\'><span>' + accordionTitle.innerHTML + '</span></button>'; let accordionTitleButton = accordionTitle.getElementsByTagName('button')[0]; accordionTitle.nextElementSibling.outerHTML = '<div id=\'js-accordion-content_' + i + '\' class=' + contentClass + '>' + accordionTitle.nextElementSibling.outerHTML + '</div>'; accordionTitleButton.addEventListener('click', () => { let accordionContent = accordionTitle.nextElementSibling; accordionTitle.classList.toggle('active'); if (accordionContent.style.maxHeight) { accordionContent.style.maxHeight = null; accordionTitleButton.setAttribute('aria-expanded', 'false'); } else { accordionTitleButton.setAttribute('aria-expanded', 'true'); accordionContent.setAttribute('style', 'display:block'); let accordionContentOpen = accordionContent.scrollHeight + 2; accordionContent.style.maxHeight = accordionContentOpen + 'px'; } /*calculate the height of all slideblockelements, header and content sperated, for the possibility of a linebreak while opening a block*/ let height = baseContentHeight; let allAccordionContentElements = document.getElementsByClassName(contentClass); let allAccordionContentTitles = document.getElementsByClassName('is_slideblock'); /*summed height of all slideblock-titles*/ for ( let j = 0; j < allAccordionContentTitles.length; j++ ) { height += parseInt(window.getComputedStyle(allAccordionContentTitles[j]).marginTop); height += parseInt(window.getComputedStyle(allAccordionContentTitles[j]).marginBottom); height += parseInt(allAccordionContentTitles[j].scrollHeight); } /*summed height of all slideblock-content-elements. using style.maxheight, instead of the scrollHeight, so we dont have to wait for the scroll-animation to finish*/ for ( let k = 0; k < allAccordionContentElements.length; k++ ) { if(parseInt(allAccordionContentElements[k].style.maxHeight) >= 0 ) { height += parseInt(allAccordionContentElements[k].style.maxHeight); } } if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.toggleMessageHandler) { window.webkit.messageHandlers.toggleMessageHandler.postMessage({ 'message': height }); } }); } }); /* tel-Links */ window.addEventListener('load', HWPhonenumberReplace.replacePhonenumbers.bind(HWPhonenumberReplace)); })(); </script>
   </head>
   <body>
      <div class="contentelement frame">
         <div id="c1325" class="frame frame-default frame-type-textmedia frame-layout-0">
            <h4 class="frame-title"> Ehrung langjährig Mitwirkender beim Schäferlauf</h4>
            <div class="ce-textpic ce-right ce-intext">
               <div class="ce-gallery ce-border" data-ce-columns="1" data-ce-images="1">
                  <div class="ce-row">
                     <div class="ce-column">
                        <figure class="image">
                           <a href="https://www.schaeferlauf-markgroeningen.de//index.php?eID=tx_cms_showpic&amp;file=691&amp;md5=8cc9320ed68fbc1977949f1d9ac2b7d7e207624c&amp;parameters%5B0%5D=eyJ3aWR0aCI6IjgwMG0iLCJoZWlnaHQiOiI2MDBtIiwiYm9keVRhZyI6Ijxib2R5&amp;parameters%5B1%5D=IHN0eWxlPVwibWFyZ2luOjA7IGJhY2tncm91bmQ6I2ZmZjtcIj4iLCJ3cmFwIjoi&amp;parameters%5B2%5D=PGEgaHJlZj1cImphdmFzY3JpcHQ6Y2xvc2UoKTtcIj4gfCA8XC9hPiIsImNyb3Ai&amp;parameters%5B3%5D=OiJ7XCJkZWZhdWx0XCI6e1wiY3JvcEFyZWFcIjp7XCJ4XCI6MCxcInlcIjowLFwi&amp;parameters%5B4%5D=d2lkdGhcIjoxLFwiaGVpZ2h0XCI6MX0sXCJzZWxlY3RlZFJhdGlvXCI6XCJOYU5c&amp;parameters%5B5%5D=IixcImZvY3VzQXJlYVwiOm51bGx9fSJ9" target="_blank"><img data-file-uid="691" class="image-embed-item" title="Ehrung langjährig Mitwirkender beim Schäferlauf" alt="Ehrung langjährig Mitwirkender beim Schäferlauf" src="https://www.schaeferlauf-markgroeningen.de//fileadmin/_processed_/d/3/csm_Ehrungsabend_b239b1d12b.jpg" width="1280" height="960" /></a>
                           <figcaption class="image-caption"> Ehrung langjährig Mitwirkender beim Schäferlauf </figcaption>
                        </figure>
                     </div>
                  </div>
               </div>
               <div class="ce-bodytext">
                  <p>Am Schäferlauf Montag fanden auf dem festlich geschmückten Marktplatz wieder die Ehrungen für langjährige ehrenamtliche Mitarbeit bei der Vorbereitung und Durchführung des Schäferlaufs, in würdevollem Rahmen statt.</p>
                  <p>Zu Beginn bedankte sich Bürgermeister Jens Hübner bei allen, die am Schäferlauf beteiligt waren. Ganz gleich ob im Festspiel, im Festzug, als Musiker, als Wettspielteilnehmer oder als Organisator, sowie auch als Gast. Insgesamt wurden in diesem Jahr 30 Personen für ihr ehrenamtliches Engagement geehrt.</p>
                  <p>Geehrt wurden:</p>
                  <p><strong>Für 10-malige Mitwirkung beim Schäferlauf:</strong></p>
                  <p>Karin Prager - Historische Zigeunergruppe<br> Jenny Maierhofer - Festspiel „Kätterle“<br> Oliver Hatt - Festspiel<br> Christiane Kull - Festspiel<br> Jan Lindner - Landjugend<br> Anna Eberlein - Landjugend<br> Florian Lowen - Schäfermusik<br> Neele Porth - Schäfertänzerin<br> Dorle Fussel - Landsknechte<br> Thomas Kohn - Landsknechte<br> Otto Breisch - Landsknechte<br> Dr. Franz Strassburger - Landsknechte<br> Lorena Wemmer - Schäfertanz<br> Ursula Baumgärtner - Landsknechte</p>
                  <p><strong>Für 20-malige Mitwirkung beim Schäferlauf:</strong></p>
                  <p>Manuela Wild - Rond oms Schof<br> Oliver Scheer - OWG Festzugsgruppe<br> Reiner Wiedenstriet - Historische Zigeunergruppe<br> Günther Mertz - Festsprecher + Festspiel „Graf“<br> Guido Lübeck - Festordner</p>
                  <p><strong>Für 25-malige Mitwirkung beim Schäferlauf:</strong></p>
                  <p>Elisabeth Sattler - OWG Festzugsgruppe<br> Anton Wieser - OWG Festzugsgruppe<br> Nicole Dunz - Schäfergericht<br> Michael Thumm - Spitalbrüder<br> Julia Gehring-Thumm - Rond oms Schaf<br> Eva Borowski - Rond oms Schaf</p>
                  <p><strong>Für 30-malige Mitwirkung beim Schäferlauf:</strong></p>
                  <p>Michael Findeis - OWG Festzugsgruppe<br> Gerhard Herrmann - OWG Festzugsgruppe<br> Sascha Wanitzek - Festspiel „Rossknecht“</p>
                  <p><strong>Für 35-malige Mitwirkung beim Schäferlauf:</strong></p>
                  <p>Ursula Hermann - OWG Festzugsgruppe<br> Anja Lautenschläger - Rond oms Schaf</p>
               </div>
            </div>
         </div>
      </div>
   </body>
</html>

          
          """,
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
          ),
        ),
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
      ),
    );
  }
}