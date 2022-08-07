# BilibiliDMB_swift
B站直播弹幕板，iOS端

野生的程序员，第一次用swift，在iPad Air 4上编写。现用现学，难免有些问题，现在只是能自己凑合着用。

> 原理参考：https://github.com/lovelyyoshino/Bilibili-Live-API/blob/master/API.WebSocket.md
> 
> 部分代码参考了https://github.com/komeiji-koishi-ww/bilibili_danmakuhime_swiftUI

软件界面预览如下：
![界面预览](https://user-images.githubusercontent.com/56810549/155886826-6880149b-5cb4-42f1-9692-4e049dd603dd.jpg)

## 使用方法
> 我没有苹果的开发者账号，所以没法发布到TestFlight或AppStore。

首先iPad上**下载Playground**，然后下载最新的[Release的`.zip`文件](https://github.com/ccslykx/BilibiliDMB_swift/releases/download/0_1_1/BilibiliDMB_0_1_1.zip)，解压出`.swiftpm`文件，复制到iCloud下（也可能是`我的iPad`下，此步复制到iCloud可能需要使用电脑操作）的Playgrounds文件夹（路径为`iCloud云盘/Playgrouds` 或 `我的iPad/Playgrounds`)，在文件App内点击打开会自动跳转到Playground，添加下面三个依赖的软件包：

- Starscream: https://github.com/daltoniam/Starscream.git 或 https://gitee.com/mirrors/starscream.git
- SwiftyJSON: https://github.com/SwiftyJSON/SwiftyJSON.git 或 https://gitee.com/idoing/SwiftyJSON.git
- SWCompression: https://github.com/tsolomko/SWCompression.git 或 https://gitee.com/L1MeN9Yu_Mirror/SWCompression.git

[点我看添加依赖示范视频](https://user-images.githubusercontent.com/56810549/183272525-5d3aeba6-8d66-438a-b183-68c8845cd27d.MP4)，注意在输入链接后需要按一下 `Enter`(`Return`)键来获取版本信息。

添加好依赖运行即可。

另：
  - 可设置默认直播间ID，`ContentView`文件里`liveRoomID`变量，默认为`23165114`。
  - 可根据自己需要修改默认显示弹幕容量（显示最新弹幕条数），`ContentView`文件里`biliLiveWebSocket`的参数`capacity`，默认为20。如同时存在大量弹幕，可能会占用大量系统资源甚至导致程序闪退。
  - 宜**设置iPad屏幕常亮**（OLED屏慎用，防止烧屏）。由于苹果的后台机制，在切到后台或锁屏后，可能会与弹幕服务器断开连接，需要手动断开再重新连接。

## 后续计划
- [ ] 增加自动重连（切后台后会被停止运行）
- [ ] 提示有人关注了直播间
- [ ] 优化礼物显示
- [x] 优化内存占用（测试时，200w人气的直播间，弹幕刷屏10多分钟，软件会闪退，可能是内存占用过高）
- [ ] 写一些有用的bug（划掉）
