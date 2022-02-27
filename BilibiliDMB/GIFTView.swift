import SwiftUI

struct GIFTView: View, Identifiable {
    let id = UUID()
    let gift: GIFT

    var body: some View {
        HStack (alignment: .center) {
            //Image
            if gift.medal_name != "" {
                MedalView(level: gift.medal_level, color: gift.medal_color, name: gift.medal_name)
            }
            Text(gift.uname) 
                .font(.custom("", size: 36))
                //.foregroundColor()
            VStack (alignment: .center) {
                Text(String(gift.timestamp.timestampToDate(format: "HH:mm:ss")))
                    .font(.custom("", size: 14))
                Text("送出了")
                    .font(.custom("", size: 18))
            }
            Text("\(gift.giftName) * \(gift.num)")
                .font(.custom("", size: 36))
        }.padding()
    }
}

