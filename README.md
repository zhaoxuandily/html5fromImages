# html5fromImages－nodejs生成器入门
最近有好多需求是把一堆图片，或者一张长图转成HTML文件在客户端展示，所以想尝试自动化这一过程，简单实验了一个HTML5生成器。

#### 功能：

根据文件夹中图片文件生成简单HTML5展示页面

#### 安装
```
$ npm install -g html5fromImages
```

#### 使用
```
$ html5fromImages [图片文件夹所在路径] [生成目标路径] [网页title]
$ html5fromImages ~/git/yqx/web/littlec-emsweb/app/help/sysc_fw/images/ dist-test  示例网页
```