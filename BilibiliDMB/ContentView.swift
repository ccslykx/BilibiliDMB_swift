import SwiftUI

struct ContentView: View {
    @State var liveRoomID: String = "23165114"
    @StateObject var ws = biliLiveWebSocket()
    @State var connected: Bool = false
    
    private var dmCounts: Int = 0
    private var giftCounts: Int = 0
    private var entryCounts: Int = 0
    
    @Namespace var dmBottomID
    @Namespace var giftBottomID
    @Namespace var entryBottomID
    
    var body: some View {
        HStack {
            Image(systemName: "house.circle") // 一个图标
                .imageScale(.large)
            TextField("直播间ID", text: $liveRoomID) // 输入直播间ID的文本框 
                .textFieldStyle(.roundedBorder)
                .frame(width: 150, height: 34, alignment: .leading)
            if (connected) {
                Button("断开") {
                    ws.socket.disconnect()
                    self.connected = false
                }.buttonStyle(.bordered)
            } else {
                Button("连接") {
                    ws.connect(room: liveRoomID)
                    self.connected = true
                    UIApplication.shared.isIdleTimerDisabled = true
                }.buttonStyle(.bordered)
            }
        }.padding(20)
        
        //MedalView(level: 22, color: 1234567, name: "狂小超") //测试用
        // 显示弹幕的部分
        HStack (alignment: .top) {
            VStack (alignment: .leading) {
                // DMs
                ScrollViewReader { proxy in
                    ScrollView() {
                        LazyVStack (alignment: .leading) {
                            ForEach (ws.DMs) { dm in
                                DMView(dm: dm).frame(alignment: .topLeading)
                            }
                            Text("")
                                .id(dmBottomID)
                                .background(.clear)
                                .foregroundColor(.clear)
                        }
                    }.onChange(of: ws.DMs) {_ in 
                        withAnimation (.easeInOut) {
                            proxy.scrollTo(dmBottomID)
                        }
                    }
                }

                // GIFTs
                ScrollViewReader { proxy in
                    ScrollView() {
                        LazyVStack (alignment: .leading) {
                            ForEach (ws.GIFTs) { gift in
                                GIFTView(gift: gift).frame(alignment: .topLeading)
                            }
                            Text("")
                                .id(giftBottomID)
                                .background(.clear)
                                .foregroundColor(.clear)
                        }
                    }.onChange(of: ws.GIFTs) {_ in 
                        withAnimation (.easeInOut) {
                            proxy.scrollTo(giftBottomID)
                        }
                    }
                }
            }.padding(20)
            
            VStack (alignment: .center) {
                if ws.ENTRYs.count > 0 {
                    Text("欢 迎")
                        .font(.custom("", size: 36))
                        .bold()
                        .foregroundColor(.primary)
                }
                // ENTRYs
                ScrollViewReader { proxy in
                    ScrollView() {
                        LazyVStack (alignment: .leading) {
                            ForEach (ws.ENTRYs) { entry in
                                HStack { // Entry View
                                    Text(entry.timestamp.timestampToDate(format: "HH:mm:ss"))
                                    Spacer()
                                    if (entry.metal_name != "") {
                                        MedalView(level: entry.metal_level, color: entry.metal_color, name: entry.metal_name)
                                    }
                                    Text(entry.uname)
                                        .foregroundColor(.primary)
                                        .font(.custom("", size: 24))
                                    Spacer()
                                }
                            }
                            Text("")
                                .id(entryBottomID)
                                .background(.clear)
                                .foregroundColor(.clear)
                        }.frame(maxWidth: 300)
                    }.onChange(of: ws.DMs) {_ in 
                        withAnimation (.easeInOut) {
                            proxy.scrollTo(entryBottomID)
                        }
                    }
                }.padding(20)
            }
        }
    }
}
