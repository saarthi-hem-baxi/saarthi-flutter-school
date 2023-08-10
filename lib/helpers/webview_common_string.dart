String getWebviewCommonScriptString() {
  return '''
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS_HTML" type="application/javascript">
      MathJax.Ajax.config.path['mhchem'] = 'https://cdnjs.cloudflare.com/ajax/libs/mathjax-mhchem/3.3.0';// capture the HTML element host
      MathJax.Hub.Config({
        messageStyle: "none",
        extensions: ['[mhchem]/mhchem.js']
      });
  </script>
  <script type="application/javascript">
      function loadJS(file) {
        var jsElm = document.createElement("script");
            jsElm.type = "application/javascript";
            jsElm.src = file;
            document.body.appendChild(jsElm);
        }
        const outputsize = () => {
            HeightHandler.postMessage(document.getElementById('content').clientHeight);   
        }
        new ResizeObserver(outputsize).observe(document.getElementById('content'));
        setTimeout(() => {
              loadJS('https://www.wiris.net/demo/plugins/app/WIRISplugins.js?viewer=image');
        }, 1000);
        function handleOnReport(type,params = []) {
          console.log("calling ");
          let string = type;
          for (const item of params) {
              string = string + "/"  + item;
          }
          ParamsHandler.postMessage(string);   
        }
  </script>
''';
}

String getHtmlTemplate(String content, String webViewCssPath,
    [String? headElements = '', String? scripts = '', String? bodyBgColor = 'white', bool? isAutoScoll]) {
  return '''<html lang="en">
              <head>
              <meta charset="UTF-8">
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
              <link
                  rel="stylesheet"
                  href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Round"
                />
                <link
                  rel="stylesheet"
                  href="$webViewCssPath"
                />
                <link rel="stylesheet"
                  href="https://fonts.googleapis.com/icon?family=Material+Icons|Material+Icons+Outlined|Material+Icons+Round" />
                <style>
                html, body {
                  margin: 0; 
                  overflow: auto; 
                  height: 100%;              
                }
                *{
                  font-family: 'Nunito', sans-serif;
                }
                </style>
                $headElements
              </head>
              <body style="background: $bodyBgColor;">
                <div id="content">
                  $content
                </div>
                $scripts
                ${getWebviewCommonScriptString()}
              </body>
            </html>
            ''';
}
