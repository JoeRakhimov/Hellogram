//
//  ChatsView.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 22/11/23.
//

import SwiftUI

struct ChatsView: View {
    
    @EnvironmentObject var vm: ContentViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(vm.filteredChats) { chat in
                    ChatItemView(chat: chat)
                }
            }
            .navigationBarTitle("Chats", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    // Handle Edit button action
                    // Add your code here
                }) {
                    Text("Edit")
                },
                trailing: HStack {
                    Button(action: {
                        // Handle Add button action
                        // Add your code here
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    Button(action: {
                        // Handle Edit button action
                        // Add your code here
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            )
            
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newSearchText in
            vm.filterChats(searchText: searchText)
        }
    }
}

#Preview {
    ChatsView()
}
