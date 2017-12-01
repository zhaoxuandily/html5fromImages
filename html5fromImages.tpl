<!doctype html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7" id="ng-app" ng-app> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8" id="ng-app" ng-app> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html> <!--<![endif]-->
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
        <!--[if lt IE 7]>
        <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!--[if lt IE 9]>
        <script src="bower_components/es5-shim/es5-shim.js"></script>
        <script src="bower_components/json3/lib/json3.min.js"></script>
        <![endif]-->
        <div class="container" class="clearfix">
{% for item in items %}
                <img src="images/{{item.filename}}">
{% endfor %}
        </div>
    </body>
</html>
