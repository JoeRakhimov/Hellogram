//
//  ChatItemView.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 20/11/23.
//

import SwiftUI
import TDLibKit

struct ChatItemView: View {
    
    var title: String
    var photo: ChatPhotoInfo?
    var subtitle: String?
    var message: String
    var time: String
    var unreadCount: Int
    var unreadMark: Int
    
    init(chat: Chat) {
        self.title = chat.title
        self.photo = chat.photo
        self.subtitle = nil
        let content = chat.lastMessage?.content
        switch content {
            case .messageText(let textMessage):
                message = textMessage.text.text
            case .messageDocument(let document):
                message = document.document.fileName
            default:
                message = "Unsupported message type"
        }
        self.time = ChatItemView.convertUnixTimestampToTimeString(chat.lastMessage?.date)
        self.unreadCount = chat.unreadCount
        print("Outgoing: " + String(chat.lastMessage?.isOutgoing == true))
        if chat.lastMessage?.isOutgoing == true {
            if chat.lastMessage?.id == chat.lastReadOutboxMessageId {
                unreadMark = 2
            } else {
                unreadMark = 1
            }
        } else {
            unreadMark = 0
        }
    }
    
    init(title: String, subtitle: String? = nil, message: String, time: String, unreadCount: Int) {
        self.title = title
        self.subtitle = subtitle
        self.message = message
        self.time = time
        self.unreadCount = unreadCount
        self.unreadMark = 0
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 56, height: 56)
                .overlay(
                    Text(extractInitialLetters(inputString: title))
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                    )
            VStack {
                HStack {
                    Text(title).bold()
                    Spacer()
                    if unreadMark == 1 {
                        Image(systemName: "checkmark")
                                            .font(.system(size: 16))
                                            .foregroundColor(.green)
                    } else if unreadMark == 2 {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16))
                            .foregroundColor(.green)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16))
                                    .foregroundColor(.green)
                                    .offset(x: 4, y: 0)
                            )
                    }
                    Text(time).foregroundColor(Color.gray).font(.system(size: 16))
                }.padding(.bottom, -2)
                HStack {
                    VStack(alignment: .leading) {
                        if subtitle != nil {
                            Text(subtitle ?? "")
                        }
                        Text(message).foregroundColor(Color.gray)
                            .truncationMode(.tail)
                            .lineLimit(subtitle != nil ? 1 : 2)
                    }
                    Spacer()
                    if unreadCount > 0 {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(unreadCount)")
                                    .foregroundColor(.white
                                ).font(.system(size: 14))
                            )
                    }
                }
                Spacer()
                Divider().background(Color.gray).padding(.trailing, -16)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 76)
        .accessibility(label: Text(title))
        .accessibility(value: Text(time+": "+message))
    }
    
    func extractInitialLetters(inputString: String) -> String {
        let words = inputString.components(separatedBy: " ")
        guard let firstWord = words.first, let lastWord = words.last else {
                return ""
        }
        let firstLetter = String(firstWord.prefix(1)).uppercased()
        let lastLetter = String(lastWord.prefix(1)).uppercased()
        if words.count == 1 {
            return firstLetter
        } else {
            return firstLetter + lastLetter
        }
    }
    
    static func convertUnixTimestampToTimeString(_ timestamp: Int?) -> String {
        if timestamp != nil {
            let currentDate = Date()
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp ?? 0))
            
            let dateFormatter = DateFormatter()
            let timeDifference = currentDate.timeIntervalSince(date)
            if timeDifference > 7 * 24 * 60 * 60 {
                dateFormatter.dateFormat = "MMM d"
            } else if timeDifference > 24 * 60 * 60 {
                dateFormatter.dateFormat = "E"
            } else {
                dateFormatter.dateFormat = "h:mm a"
            }
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
}

#Preview {
    ChatItemView(
        title: "Aziza Rakhimova", subtitle: "You", message: "Hello long text test how it looks like test long text how it looks like long", time: "16:03", unreadCount: 5
    )
}
