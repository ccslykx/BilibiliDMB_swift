import SwiftUI

struct MedalView: View {
    var level: Int        // 粉丝等级
    var color: UInt32     // 粉丝牌颜色
    var name: String      // 粉丝牌名称
    
    var body: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(dec: color))
            .frame(width: 100, height: 24, alignment: .center)
            .overlay{
                HStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.clear)
                        .frame(width: 66, height: 18, alignment: .center)
                        .overlay{
                            Text(name)
                                .foregroundColor(.white)
                                .font(.custom("", size: 16))
                                .scaledToFill()
                        }
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.white)
                        .frame(width: 20, height: 18, alignment: .center)
                        .overlay{
                            Text(String(level))
                                .foregroundColor(Color(dec: color))
                                .font(.custom("", size: 16))
                                .scaledToFill()
                        }
                    }
            }
    }
}
