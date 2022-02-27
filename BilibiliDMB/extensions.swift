import SwiftUI
// 进房间时发送的JSON
struct BilibiliLiveRoom: Codable {
    let clientver: String = "1.14.3"
    let platform: String = "web"
    let protover: UInt = 2
    let roomid: UInt
    let uid: String = "0"
    let type: UInt = 2
    let key: String
}

//GET Room ID
//let apiGetInfoByRoom = "https://api.live.bilibili.com/xlive/web-room/v1/index/getInfoByRoom?room_id="
struct getInfoByRoom: Codable {
    let code: Int
    let message: String
    let ttl: Int?
    let data: getInfoByRoom_Infos
}

struct getInfoByRoom_Infos: Codable {
    let room_info: getInfoByRoom_Infos_roomInfo
    // ...
}
struct getInfoByRoom_Infos_roomInfo: Codable {
    let uid: Int
    let room_id: Int
    let short_id: Int
    let title: String
    let cover: String
    // ...
    let live_status: Int
    let live_start_time: Int
}

//----------------------
//GET WebSocket address & port
//let apiGetDanmuInfo = "https://api.live.bilibili.com/xlive/web-room/v1/index/getDanmuInfo?id="
struct getDanmuInfo: Codable {
    let code: Int
    let message: String
    let ttl: Int?
    let data: danmuInfo_data
}

struct danmuInfo_data: Codable {
    let group: String
    let business_id: Int
    let refresh_row_factor: Double
    let refresh_rate: Int
    let max_delay: Int
    let token: String
    let host_list: [danmuInfo_data_hostList]
}

struct danmuInfo_data_hostList: Codable {
    let host: String
    let port: Int
    let wss_port: Int
    let ws_port: Int
}

struct DM: Identifiable { // cmd = DANMU_MSG
    let timestamp: Int
    let uid: Int?
    let color: UInt32
    let metal_level: Int
    let metal_color: UInt32
    let metal_name: String
    let uname: String
    let content: String
    let id = UUID()
}

extension DM: Equatable {
    static func == (l: DM, r: DM) -> Bool {
        if l.id == r.id {
            return true
        } else {
            return false
        }
    }
    
    static func != (l: DM, r: DM) -> Bool {
        if l.id == r.id {
            return false
        } else {
            return true
        }
    }
}

struct GIFT: Identifiable {
    let is_first: Bool
    
    let timestamp: Int
    
    //let super_gift_num: Int
    let combo_stay_time: Int
    
    let giftId: Int
    //let remain: Int
    let price: Int
    //let uid: Int
    let num: Int
    //let giftType: Int
    
    // medal info
    let medal_level: Int
    let medal_color: UInt32
    let medal_color_start: UInt32 
    let medal_color_border: UInt32
    let medal_color_end: UInt32
    let medal_name: String 
    
    let uname: String
    let giftName: String
    
    let id = UUID()
}

extension GIFT: Equatable {
    static func == (l: GIFT, r: GIFT) -> Bool {
        if l.id == r.id {
            return true
        } else {
            return false
        }
    }
    
    static func != (l: GIFT, r: GIFT) -> Bool {
        if l.id == r.id {
            return false
        } else {
            return true
        }
    }
}

struct ENTRY: Identifiable {
    let timestamp: Int

    let metal_level: Int
    let metal_color: UInt32
    let metal_name: String
    
    //let uname_color: String
    let uname: String

    let id = UUID()
}

extension ENTRY: Equatable {
    static func == (l: ENTRY, r: ENTRY) -> Bool {
        if l.id == r.id {
            return true
        } else {
            return false
        }
    }
    
    static func != (l: ENTRY, r: ENTRY) -> Bool {
        if l.id == r.id {
            return false
        } else {
            return true
        }
    }
}



extension Int {
    func timestampToDate(format: String = "yyyy年MM月dd日 HH:mm:ss") -> String{
        let df = DateFormatter()
        df.dateFormat = format
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return df.string(from: date)
    }
}


/*
 https://stackoverflow.com/questions/64143156/how-to-use-color-with-rgb-or-hex-value-in-swiftui-using-swift-5
 
 The UIColor init method UIColor(red:green:blue:alpha) takes float values from 0 to 1 for each value.
 
 Any value ≥ 1.0 is going to "max out" that color. So an expression like UIColor(red: 220, green: 24, blue: 311, alpha: 1) will set all 3 color channels and alpha to 1.0, resulting in white. So would UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 
 You could create an extension to UIColor that adds convenience initializers that would take values of different types. First, and initializer that would take values from 0-255 for each. Then you could create another intializer UIColor.init(hexString:String).
 
 The one that took values from 0-255 would be a lot easier to write. The one that took hex strings would involve implementing a hex parser. I bet somebody has already written it though.
 
 Take a look at this code, for example:
 
 https://gist.github.com/anonymous/fd07ecf47591c9f9ed1a
 */

extension Color {
    init(dec: UInt32, alpha: Double = 1) {
        let RGB = (
            R: Double((dec >> 16) & 0xff) / 255,
            G: Double((dec >> 08) & 0xff) / 255,
            B: Double((dec >> 00) & 0xff) / 255
        )
        self.init(
            .sRGB,
            red: RGB.R,
            green: RGB.G,
            blue: RGB.B,
            opacity: alpha
        )
    }
}
