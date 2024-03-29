// 单独一条弹幕的视图

import SwiftUI

struct DMView: View, Identifiable {
    let id = UUID()
    let dm: DM
//    @State var F_time: Font = .custom("", size: 16) // 时间的字体
//    @State var F_uname: Font = .custom("", size: 18) // 昵称的字体
//    @State var F_content: Font = .custom("", size: 36) // 弹幕内容的字体
    
    var body: some View {
        HStack (alignment: .top){
            VStack (alignment: .leading) {
                Text(String(dm.timestamp.timestampToDate()))
                    .foregroundColor(Color(dec: dm.color))
                    .font(.custom("", size: 16))
                HStack (alignment: .center) {
                    if (dm.metal_name != "") {
                        MedalView(level: dm.metal_level, color: dm.metal_color, name: dm.metal_name)
                    }
                    Text(dm.uname)
                        .foregroundColor(Color(dec: dm.color))
                        .font(.custom("", size: 18))
                }
            }.padding()
            Text(dm.content)
                .foregroundColor(Color(dec: dm.color))
                .font(.custom("", size: 36))
                .padding()
        }
    }
    
    
}
