import SwiftUI

struct ContentView: View {
    @State var liveRoomID: String = "41515"//"23165114"
    @StateObject var ws = biliLiveWebSocket()
    @State private var connected: Bool = false
//    
//    private var dmCounts: Int = 0
//    private var giftCounts: Int = 0
//    private var entryCounts: Int = 0
    
    @Namespace private var dmBottomID
    @Namespace private var giftBottomID
    @Namespace private var entryBottomID
    
//    @State private var DM_VIEWs: [DMView] = []
//    @State private var GIFT_VIEWs: [GIFTView] = []
    //private var ENTRY_VIEWs: 
    
    private var timer = DispatchSource.makeTimerSource()
    
    // Setting
    private var capacity: Int = 5
     
    init() {
//        timer.schedule(deadline: .now(), repeating: .seconds(1))
//        timer.setEventHandler() {
//            DispatchQueue.main.async {
//                var info = mach_task_basic_info()
//                let MACH_TASK_BASIC_INFO_COUNT = MemoryLayout<mach_task_basic_info>.stride/MemoryLayout<natural_t>.stride
//                var count = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
//                
//                let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
//                    $0.withMemoryRebound(to: integer_t.self, capacity: MACH_TASK_BASIC_INFO_COUNT) {
//                        task_info(mach_task_self_,
//                                  task_flavor_t(MACH_TASK_BASIC_INFO),
//                                  $0,
//                                  &count)
//                    }
//                }
//                
//                if kerr == KERN_SUCCESS {
//                    print("Memory in use : \(info.resident_size/1024) KB")
//                }
//                else {
//                    print("Error with task_info(): " +
//                          (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
//                }
//            }
//        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "house.circle") // 一个图标
                .imageScale(.large)
            TextField("直播间ID", text: $liveRoomID) // 输入直播间ID的文本框 
                .textFieldStyle(.roundedBorder)
                .frame(width: 150, height: 34, alignment: .leading)
            if (self.connected) {
                Button("断开") {
                    ws.disConnect()
                    self.connected = false
//                    timer.cancel()
                }.buttonStyle(.bordered)
            } else {
                Button("连接") {
                    ws.connect(room: liveRoomID)
                    self.connected = true
//                    UIApplication.shared.isIdleTimerDisabled = true
//                    Task.init() {
//                        timer.resume()
//                    }
                }.buttonStyle(.bordered)
            }
        }.padding(20)
        
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
//                            ForEach (DM_VIEWs) { dmview in
//                                dmview
//                            }
                            Text("")
                                .id(dmBottomID)
                                .background(.clear)
                                .foregroundColor(.clear)
                        }
                    }.onChange(of: ws.DMs) { _ in 

                        //print("DM_VIEWs.count = \(DM_VIEWs.count)    Memory")
                        withAnimation (.easeInOut) {
                            proxy.scrollTo(dmBottomID)
                        }
                    }
                }
                Divider()
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
