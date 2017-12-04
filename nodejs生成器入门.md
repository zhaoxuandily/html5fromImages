# html5fromImages－nodejs生成器入门

#### 参考文档
> 零基础十分钟教你用Node.js写生成器：你只需要5步

用Node.js写生成器是件非常简单的事儿，原因是

- Node.js模块开发简单，js语法，而且二进制cli模块也极其简单
- Npm发布包是所有开源的包管理器里最简单好用的
- 辅助模块多，将近40万个左右

这里精简一下，你只需要5步

1. 初始化模块
1. cli二进制模块
1. 模板引擎使用
1. 解析cli参数和路径
1. npm发布

这里假定你已经安装了Node.js，至于是什么版本，如何安装的并不重要。

先要介绍一下，什么是Npm？

https://www.npmjs.com/

npm is the package manager for

  - browsers
  - javascript
  - nodejs
  - io.js
  - mobile
  - bower
  - docpad
  - test

简单理解：NPM（node package manager），通常称为node包管理器。顾名思义，它的主要功能就是管理node包，包括：安装、卸载、更新、查看、搜索、发布等。只要安装了Node.js，它会默认安装的。

## 1）初始化模块

确认模块名称是否已被发布

```
$ npm info html5fromimages
```

如果没有找到对应的包，说明你可以使用这个名字，然后在github建立仓库，clone到本地即可

```
$ git clone html5fromimages
$ npm init -y
```

生成package.json文件，此文件为模块的描述文件，非常重要。

```
{
  "name": "html5fromimages",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

说明

- main是模块的入口文件，即普通代码对外提供调用的api入口。
- scripts是npm scripts非常便利的，只要在package.json所在目录下，你执行npm test就会调用这里的test配置。如果是test，start等内置命令之外的，可以通过`npm run xxx`来定义

## 2）cli二进制模块

Node.js分2种模块

- 普通模块，供代码调用
- 二进制模块，提供cli调用

大家都知道，生成器是cli工具，所以我们应该使用cli二进制模块

手动修改package.json文件

```
{
  "name": "a",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "bin": {
    "html5fromImages": "html5fromImages.js"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

这里主要增加里一个`bin`的配置，bin里的`html5fromImages`为cli的具体命令，它具体执行的文件是html5fromImages.js。

既然`html5fromImages`的执行文件是`html5fromImages.js`，我们当然需要创建它

```
$ touch html5fromImages.js
```

填写

```
  #!/usr/bin/env node

  var argv = process.argv;
  var filePath = __dirname;
  var currentPath = process.cwd();

  console.log(argv)
  console.log(filePath)
  console.log(currentPath)

```

说明

- argv是命令行的参数
- filePath是当前文件的路径，也就是以后安装后文件的路径，用于存放模板文件非常好
- currentPath是当前shell上下文路径，也就是生成器要生成文件的目标位置

至此，二进制模块的代码就写完了，下面我们测一下

1）本地安装此模块

在package.json文件路径下，执行

```
$ npm link

/Users/sang/.nvm/versions/node/v4.4.5/bin/gen -> /Users/sang/.nvm/versions/node/v4.4.5/lib/node_modules/a/gen.js
/Users/sang/.nvm/versions/node/v4.4.5/lib/node_modules/a -> /Users/sang/workspace/github/i5ting/a
```

此时说明已经安装成功了。

2）html5fromImages

```
$ html5fromImages
[ '/Users/sang/.nvm/versions/node/v4.4.5/bin/node',
  '/Users/sang/.nvm/versions/node/v4.4.5/bin/gen' ]
/Users/sang/workspace/github/i5ting/a
/Users/sang/workspace/github/i5ting/a
```

可以换不同的目录来测试一下，看看结果的不同，来体会上面3个变量的妙用。

## 3）模板引擎使用

模板引擎是一种复用思想，通过定义模板，用的时候和数据一起编译，生成html，以便浏览器渲染。从这个定义里我们可以找出几个关键点

> 编译(模板 + 数据) => html

模板引擎有好多种，下面介绍2种典型的模板引擎

- ejs：嵌入js语法的模板引擎（e = embed），类似于jsp，asp，erb的，在html里嵌入模板特性，如果熟悉html写起来就非常简单，只要区分哪些地方是可变，哪些地方是不变即可
- jade：缩进式极简写法的模板引擎，发展历史 HAML -> Jade -> Slim -> Slm，最早是ruby里有的，目前以jade用的最多，这种写法虽好，，但需要大脑去转换，这其实是比较麻烦的，如果对html不是特别熟悉，这种思维转换是非常难受的。

更多见 https://github.com/tj/consolidate.js#supported-template-engines

这里我们选一个，目前Node.js里最火的应该也是最好的[Nunjucks](https://mozilla.github.io/nunjucks/)，我感觉它和ejs比较像，但跟jade一样强大，语法据说出自Python的某款模板引擎

```
$ npm install --save nunjucks
```

然后我们修改模板引擎

```
  #!/usr/bin/env node

  var fs = require('fs')
  var nunjucks = require('nunjucks')

  var tpl = fs.readFileSync(filePath +'/html5fromImages.tpl').toString()

  var compiledData = nunjucks.renderString(tpl, {'items':res,'title':title});

  fs.writeFileSync(distPath + '/index.html', compiledData)

  console.log('----finished----');
```

这里我们只看nunjucks代码。

- 1）引入nunjucks模块
- 2）nunjucks.renderString方法是编译模板用的，它有2个参数
  - 第一个是模板字符串
  - 第二个是json数据
- 3）compiledData就是编译后的结果

结合上面说的模板引擎原理，

> 编译(模板 + 数据) => html

再理解一下，效果会更好。

创建一个html5fromImages.tpl，内容为

```
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

```

下面我们看看如何用html5fromImages.js来读取模板。

```
var fs = require('fs')
var nunjucks = require('nunjucks')

var tpl = fs.readFileSync('./html5fromImages.tpl').toString()

var compiledData = nunjucks.renderString(tpl, { username: 'James' });

console.log(compiledData)
```

- 1）引入fs模块，因为要读取文件
- 2）fs.readFileSync('./html5fromImages.tpl').toString()，使用了一个读取文件的同步方法，并把文件内容转成字符串，原来是buffer

读文件还是挺简单吧。那么写文件呢？

```
fs.writeFileSync('./html5fromImages.html', compiledData)
```

至此，一个生成器的模型就出来

```
  #!/usr/bin/env node

  var fs = require('fs')
  var nunjucks = require('nunjucks')

  var tpl = fs.readFileSync('./html5fromImages.tpl').toString()

  var compiledData = nunjucks.renderString(tpl, {'items':res,'title':title});

  console.log(compiledData)

  fs.writeFileSync('./html5fromImages.html', compiledData)
```

思考一下，可变得有哪些？

- './html5fromImages.tpl'是输入模板
-  {'items':res,'title':title} 要编译的数据
- './html5fromImages.html'是最终的输出

那么，剩下的事儿就是围绕可变得内容来构造你想要的功能。

## 4）解析cli参数和路径

要说生成器，最经典的是rails的scaffold，曾经缔造了一个15分钟blog的神话

```
$ rails g book name:string coordinates:string
```

如果我们要实现它，怎么做呢？

- rails g是固定的用于生成的命令
- book是模型名称，俗称表名
- 而name和coordinates都是字段名称，string是表中的类型

可变的只有表名和字段信息。所以只要解析到这些就够了，换成我们的gen命令，大概是这样

```
$ gen book name:string coordinates:string
```

html5fromImages.js代码

```
  #!/usr/bin/env node

  var argv = process.argv;
  console.log(argv)
```

执行gen命令的结果是

```
$ gen book name:string coordinates:string
[ '/Users/sang/.nvm/versions/node/v4.4.5/bin/node',
  '/Users/sang/.nvm/versions/node/v4.4.5/bin/gen',
  'book',
  'name:string',
  'coordinates:string' ]
```

这时候，可以再仔细看看我们html5fromImages.js的代码
- 读写文件使用 fs
- 模版引擎使用nunjucks 具体语法查看 http://mozilla.github.io/nunjucks/（可能需要代理）
- 复制文件夹使用child_process shell命令
- 对文件名排序 Array.sort( [ sortFunction ] ) 比较其中数字大小
- process.argv 获取输入变量 从第3位开始
- 排除隐藏文件等 判断是否为图片文件
```
  #!/usr/bin/env node

  var fs = require('fs')
  var nunjucks = require('nunjucks')
  var child_process = require('child_process')
  //复制文件夹
  function copyDir(src, dist) {
    child_process.spawn('cp', ['-rf', src, dist]);
  }

  //根据数字比较文件名
  function sortNumber(a,b)
  {
      var first = a.filename.replace(/[^\d]/g, '')
      var secend = b.filename.replace(/[^\d]/g, '')
      return first - secend;
  }

  //判断是否为图片文件
  function checkImageFile(file){
      if( file.substring(file.indexOf('.')) =='.png' ||
          file.substring(file.indexOf('.')) =='.PNG' ){
          return true;
      }
      return false;
  }
  var filePath = __dirname;
  var currentPath = process.cwd();

  var imagesPath = process.argv[2] ? process.argv[2] : currentPath;
  var distPath =  process.argv[3] ? process.argv[3] : currentPath + '/dist-' + Date.now();
  var title = process.argv[4] ? process.argv[4] :'';

  console.log(filePath);
  console.log(currentPath);
  console.log('图片所在路径:' + imagesPath);
  console.log('生成文件路径:' + distPath);

  var res=[],html = '', files = fs.readdirSync(imagesPath);

  if(!fs.existsSync(distPath)){
      //rmDir(distPath);
      fs.mkdirSync(distPath);
  }

  files.forEach(function(file){
      var filename = file
      , stat = fs.lstatSync( imagesPath + '/'+filename);

      if (!stat.isDirectory() && checkImageFile(filename) ){

          res.push({'filename':filename});
      }
  });
  res.sort(sortNumber);

  var tpl = fs.readFileSync(filePath +'/html5fromImages.tpl').toString()

  var compiledData = nunjucks.renderString(tpl, {'items':res,'title':title});

  fs.writeFileSync(distPath + '/index.html', compiledData)
  copyDir(imagesPath ,distPath+ '/images');

  console.log('----finished----');
```

至此，完成了所有代码。此时你在任意目录输入

```
$ html5fromImages [图片文件夹所在路径] [生成目标路径] [网页title]
$ html5fromImages ~/git/yqx/web/littlec-emsweb/app/help/sysc_fw/images/ dist-test  示例网页
```

你会发现目标路径下会有一个html5fromImages.html文件，和images文件夹。

## 5）npm发布

在package.json目录里执行

```
$ npm publish . 
```

就可以了发布成功了。

如果你想增加版本号，再次发布，你需要2步

```
$ npm version patch
$ npm publish .
```

你可以自己测试一下

```
$ npm i -g xxxxxx
```

##发布时遇到的问题

##### 1. 由于设置了npm镜像 http://npmjs.taobao.org/
重置为官方镜像
```
$ npm config set registry http://registry.npmjs.org/
```
然后 按照提示 注册 adduser 登陆 再publish 就能够成功

##### 2. 注意npm的模块名不能有大写字母

此时 https://www.npmjs.com/package/html5fromimages 上已经能够找到我们发布的包了

通过
```
$ npm install -g html5fromImages
```
就可以使用了

## 更多

整体来说，还是一个非常实用的模块，而且比较简单，适合入门。

目前只是基础版本，有待进一步完善优化
- 异常：各种可能的异常捕获及处理
- 测试：
- 工具模块：比如使用debug模块处理调试信息，日志等
- argv解析模块：commander 或者yargs
- 实用工具，比如各种大小写转换，驼峰式

## 最后

可以开始尝试写我们自己的项目生成器啦。
