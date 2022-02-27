# BilibiliDMB_swift
b站直播弹幕板，iOS端

野生的程序员，第一次用swift，在iPad Air 4上编写。现用现学，难免有些问题，现在只是能自己凑合着用。

> 原理参考：https://github.com/lovelyyoshino/Bilibili-Live-API/blob/master/API.WebSocket.md
> 部分代码参考了https://github.com/komeiji-koishi-ww/bilibili_danmakuhime_swiftUI

软件界面预览如下：
![界面预览](https://user-images.githubusercontent.com/56810549/155886826-6880149b-5cb4-42f1-9692-4e049dd603dd.jpg)

## 使用方法
> 我没有苹果的开发者账号，所以没法发布到TestFlight或AppStore。

首先iPad上下载Playground

然后，方案一：
新建一个项目，自行添加并复制BilibiliDMB目录下的swift文件，添加依赖的软件包
- [Starscream](https://github.com/daltoniam/Starscream.git)
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON.git)
- [SWCompression](https://github.com/tsolomko/SWCompression.git)
运行即可。

方案二：
下载release的[BilibiliDMB_Preview.swiftpm](https://github.com/ccslykx/BilibiliDMB_swift/releases/download/Preview/BilibiliDMB_Preview.swiftpm)文件，复制到iPad下的Playground文件夹（可能是iCloud下），点击打开。（未测试）

## 后续计划
- [ ] 增加自动重连（切后台后会被停止运行）
- [ ] 提示有人关注了直播间
- [ ] 优化礼物显示
- [ ] 优化内存占用（测试时，200w人气的直播间，弹幕刷屏10多分钟，软件会闪退，可能是内存占用过高）
- [ ] 写一些有用的bug（划掉）
