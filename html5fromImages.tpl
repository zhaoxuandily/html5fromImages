<!doctype html>

<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title>{{title}}</title>
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="yes" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">

        <style>
        body,html {
              margin:0 !important;
              text-align:justify;
        }
        .container{
          width:100%;
        }
        img{
          width:100%;
          display: block;
        }
        </style>
    </head>
    <body>
        <div class="container" class="clearfix">
{% for item in items %}
                <img src="images/{{item.filename}}">
{% endfor %}
        </div>
    </body>
</html>
