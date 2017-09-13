# Incremental-hot-update
react-native iOS增量热更新实现Demo

不使用第三方服务实现增量热更新

Demo使用流程:
  
    1.npm i
  
    2.react-native link
    
    3.npm run bundle-ios
  
    4.使用Xcode打开,以release模式运行,控制台会打印热更新流程

流程图:

![](http://oif61bzoy.bkt.clouddn.com/15047699265651.jpg)

diff包使用一位网友开源的GUI diff包生成工具 下载地址:http://newfun1994.github.io/react-native-DiffPatch/AutoDiff.zip


