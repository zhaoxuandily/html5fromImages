#!/usr/bin/env node

var fs = require('fs')
var nunjucks = require('nunjucks')
var child_process = require('child_process')


//复制文件夹
function copyDir(src, dist) {
  child_process.spawn('cp', ['-rf', src, dist]);
}
/*
    //删除文件夹
    function rmDir(path){
        child_process.spawn('rm', ['-rf', path]);
    }
*/
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