import SwiftUI
import Starscream // https://github.com/daltoniam/Starscream.git
import SwiftyJSON // https://github.com/SwiftyJSON/SwiftyJSON.git
import SWCompression // https://github.com/tsolomko/SWCompression.git

class biliLiveWebSocket: NSObject, ObservableObject {
    // 房间ID
    var roomid0: String = ""
    // 真实房间ID
    private var roomid: String = ""
    // 直播地址
    var address: String = "broadcastlv.chat.bilibili.com"
    // 端口（没有用到）
    var ws_port: Int = 2244
    // SSL端口
    var wss_port: Int = 443
    // token，由API获取
    var token: String = ""
    var socket: WebSocket!
    // 刷新速率（ms）
    var refreshRate: Int = 1000
    // 两个API
    let apiGetInfoByRoom = "https://api.live.bilibili.com/xlive/web-room/v1/index/getInfoByRoom?room_id="
    let apiGetDanmuInfo = "https://api.live.bilibili.com/xlive/web-room/v1/index/getDanmuInfo?id="
    
    var heartbeatTimer: Timer? = nil
    
    @Published var DMs: [DM] = []
    @Published var GIFTs: [GIFT] = []
    @Published var ENTRYs: [ENTRY] = []
    
    override init() {
        super.init()
        DMs.reserveCapacity(3)
        GIFTs.reserveCapacity(3)
        ENTRYs.reserveCapacity(3)
    }

    enum message: String {
        case dm = "DANMU_MSG" //弹幕消息
        case gift = "SEND_GIFT" //投喂礼物
        case entry = "INTERACT_WORD" //进入房间
    }
    
    private func preConnect(room: String) {
        let roomInfoData = try! Data(contentsOf: URL(string: apiGetInfoByRoom + room)!)
        let roomInfo = try! JSONDecoder().decode(getInfoByRoom.self, from: roomInfoData)
        self.roomid = String(roomInfo.data.room_info.room_id)
        
        let danmuInfoData = try! Data(contentsOf: URL(string: apiGetDanmuInfo + roomid)!)
        let danmuInfo = try! JSONDecoder().decode(getDanmuInfo.self, from: danmuInfoData)
        self.token = danmuInfo.data.token
        self.refreshRate = danmuInfo.data.refresh_rate
        self.address = danmuInfo.data.host_list[0].host
        self.ws_port = danmuInfo.data.host_list[0].ws_port
        self.wss_port = danmuInfo.data.host_list[0].wss_port
    }
    
    func connect(room: String) {
        self.preConnect(room: room)
        var wsURL: URL = URL(string: "wss://broadcastlv.chat.bilibili.com:443/sub")!
        socket = WebSocket(request: URLRequest(url: wsURL))
        socket.delegate = self
        socket.connect()
    }
    
    func packet(_ type:Int) -> Data { 
        // 该函数修改自https://github.com/komeiji-koishi-ww/bilibili_danmakuhime_swiftUI/
        
        //数据包
        var bodyDatas = Data()
        
        switch type {
        case 7: //认证包
            let str = "{\"uid\": 0,\"roomid\": \(self.roomid),\"protover\": 2,\"platform\": \"web\",\"type\": 2,\"clientver\": \"1.14.3\",\"key\": \"\(self.token)\"}"
            bodyDatas = str.data(using: String.Encoding.utf8)!
            
        default: //心跳包
            bodyDatas = "{}".data(using: String.Encoding.utf8)!
            
        }
        
        //header总长度,  body长度+header长度
        var len: UInt32 = CFSwapInt32HostToBig(UInt32(bodyDatas.count + 16))
        let lengthData = Data(bytes: &len, count: 4)
        
        //header长度, 固定16
        var headerLen: UInt16 = CFSwapInt16HostToBig(UInt16(16))
        let headerLenghData = Data(bytes: &headerLen, count: 2)
        
        //协议版本
        var versionLen: UInt16 = CFSwapInt16HostToBig(UInt16(1))
        let versionLenData = Data(bytes: &versionLen, count: 2)
        
        //操作码
        var optionCode: UInt32 = CFSwapInt32HostToBig(UInt32(type))
        let optionCodeData = Data(bytes: &optionCode, count: 4)
        
        //数据包头部长度（固定为 1）
        var bodyHeaderLength: UInt32 = CFSwapInt32HostToBig(UInt32(1))
        let bodyHeaderLengthData = Data(bytes: &bodyHeaderLength, count: 4)
        
        //按顺序添加到数据包中
        var packData = Data()
        packData.append(lengthData)
        packData.append(headerLenghData)
        packData.append(versionLenData)
        packData.append(optionCodeData)
        packData.append(bodyHeaderLengthData)
        packData.append(bodyDatas)
        
        return packData
    }
    
    func unpack(data: Data) -> String {
        let header = data.subdata(in: Range(NSRange(location: 0, length: 16))!)
        //let packetLen = header.subdata(in: Range(NSRange(location: 0, length: 4))!)
        //let headerLen = header.subdata(in: Range(NSRange(location: 4, length: 2))!)
        let protocolVer = header.subdata(in: Range(NSRange(location: 6, length: 2))!)
        let operation = header.subdata(in: Range(NSRange(location: 8, length: 4))!)
        //let sequenceID = header.subdata(in: Range(NSRange(location: 12, length: 4))!)
        let body = data.subdata(in: Range(NSRange(location: 16, length: data.count-16))!)
        
        var result = ""
        
        switch protocolVer._2BytesToInt() {
        case 0: // JSON
            try! result = JSON(data: body).rawString()!
            
        case 1: // 人气值
            break
            
        case 2: // zlib JSON
            guard let unzipData = try? ZlibArchive.unarchive(archive: body) else {
                print("[Warning] Failed Unzip Data")
                break
            }
            unpackUnzipData(data: unzipData)
            
        case 3: // brotli JSON
            break
            
        default:
            break
        }
        
        return result
    }
    
    func unpackUnzipData(data: Data) {
        let bodyLen = data.subdata(in: Range(NSRange(location: 0, length: 4))!)._4BytesToInt()
        if bodyLen > 16 {
            let cur = data.subdata(in: Range(NSRange(location: 16, length: bodyLen-16))!)
            A(json: JSON(cur))
            if data.count > bodyLen {
                let res = data.subdata(in: Range(NSRange(location: bodyLen, length: data.count-bodyLen))!)
                unpackUnzipData(data: res)
            }
        }
    }
    
    func A(json: JSON) {
        switch json["cmd"].stringValue {
        case message.dm.rawValue:
            if json["info"].arrayValue[3].count <= 0 {
                DMs.append(
                    DM(
                        timestamp: json["info"].arrayValue[9]["ts"].intValue,
                        uid: json["info"].arrayValue[2].arrayValue[0].intValue,
                        color: json["info"].arrayValue[0].arrayValue[3].uInt32Value, //DEC
                        metal_level: 0,
                        metal_color: 16777215,
                        metal_name: "",
                        uname: json["info"].arrayValue[2].arrayValue[1].stringValue,
                        content: json["info"].arrayValue[1].stringValue
                    )
                )
            } else {
                DMs.append(
                    DM(
                        timestamp: json["info"].arrayValue[9]["ts"].intValue,
                        uid: json["info"].arrayValue[2].arrayValue[0].intValue,
                        color: json["info"].arrayValue[0].arrayValue[3].uInt32Value, //DEC
                        metal_level: json["info"].arrayValue[3].arrayValue[0].intValue,
                        metal_color: json["info"].arrayValue[3].arrayValue[4].uInt32Value,
                        metal_name: json["info"].arrayValue[3].arrayValue[1].stringValue,
                        uname: json["info"].arrayValue[2].arrayValue[1].stringValue,
                        content: json["info"].arrayValue[1].stringValue
                    )
                )
            }
        case message.gift.rawValue:
            GIFTs.append(
                GIFT(
                    is_first: json["data"]["is_first"].boolValue,
                    timestamp: json["data"]["timestamp"].intValue,
                    
                    //super_gift_num: json["data"]["super_gift_num"].intValue,
                    combo_stay_time: json["data"]["combo_stay_time"].intValue,
                    
                    giftId: json["data"]["giftId"].intValue,
                    //remain: json["data"]["remain"].intValue,
                    price: json["data"]["price"].intValue,
                    //uid: json["data"]["uid"].intValue,
                    num: json["data"]["num"].intValue,
                    //giftType: json["data"]["giftType"].intValue,
                    medal_level: json["data"]["medal_info"]["medal_level"].intValue,
                    medal_color: json["data"]["medal_info"]["medal_color"].uInt32Value,
                    medal_color_start: json["data"]["medal_info"]["medal_color_start"].uInt32Value,
                    medal_color_border: json["data"]["medal_info"]["medal_color_border"].uInt32Value,
                    medal_color_end: json["data"]["medal_info"]["medal_color_end"].uInt32Value,
                    medal_name: json["data"]["medal_info"]["medal_name"].stringValue,
                    
                    uname: json["data"]["uname"].stringValue,
                    giftName: json["data"]["giftName"].stringValue
                )
            )
        
        case message.entry.rawValue:
            ENTRYs.append(
                ENTRY(
                    timestamp: json["data"]["timestamp"].intValue,
                    metal_level: json["data"]["fans_medal"]["metal_level"].intValue,
                    metal_color: json["data"]["fans_medal"]["metal_color"].uInt32Value,
                    metal_name: json["data"]["fans_medal"]["metal_name"].stringValue,
                    uname: json["data"]["uname"].stringValue
                )
            )

        default:
            break
        }
    }
    
    @objc func sendHeartbeat() {
        heartbeatTimer = Timer(timeInterval: 30, repeats: true) {_ in 
            self.socket.write(data: self.packet(2))
        }
        RunLoop.current.add(heartbeatTimer!, forMode: .common)
    }
}

extension biliLiveWebSocket: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        
        case .connected(let header):
            print("[log] Connected! Header is \(header)")
            socket.write(data: self.packet(7)) {
                self.performSelector(onMainThread: #selector(self.sendHeartbeat), with: nil, waitUntilDone: false) // NSObject
            }
            
        case .disconnected(let reason, let code):
            print("[log] Disconnected: \(reason) with code: \(code)")
            
        case .binary(let data):
            unpack(data: data)
            
        case .text(_):
            break
            
        case .error(let error):
            print("[Error] \(String(describing: error))")
            
        case .cancelled:
            break
            
        case .ping(_), .pong(_), .viabilityChanged(_), .reconnectSuggested(_):
            break
                
        }
    }
}

extension Data {
    func _4BytesToInt() -> Int {
        var value: UInt32 = 0
        let data = NSData(bytes: [UInt8](self), length: self.count)
        data.getBytes(&value, length: self.count) // 把data以字节方式拷贝给value？
        value = UInt32(bigEndian: value)
        return Int(value)
    }
    
    func _2BytesToInt() -> Int {
        var value: UInt16 = 0
        let data = NSData(bytes: [UInt8](self), length: self.count)
        data.getBytes(&value, length: self.count) // 把data以字节方式拷贝给value？
        value = UInt16(bigEndian: value)
        return Int(value)
    }
}
