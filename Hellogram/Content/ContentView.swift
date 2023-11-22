//
//  ContentView.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 14/11/23.
//

import SwiftUI
import TDLibKit

struct ContentView: View {
    
    @StateObject var vm = ContentViewModel()
    @State private var selectedTab = 1
    
    var body: some View {
        if vm.loggedIn {
            TabView(selection: $selectedTab) {
                ContactsView()
                            .tabItem {
                                Image(systemName: "person.circle")
                                Text("Contacts")
                            }
                            .tag(0)

                ChatsView().environmentObject(vm)
                            .tabItem {
                                Image(systemName: "message")
                                Text("Chats")
                            }
                            .tag(1)

                SettingsView().environmentObject(vm)
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(2)
            }
            .background(Color.gray)
            .onAppear {
                        UITabBar.appearance().barTintColor = UIColor.white
            }
        } else {
            VStack {
                Text("Hint: \(vm.hint)")
                TextField("Phone", text: $vm.phone)
                TextField("Code", text: $vm.code)
                SecureField("2FA", text: $vm.twofa)
                Button("Submit") {
                    Task {
                        try await vm.submit()
                    }
                }
            }.padding()
        }
    }
    
    struct ContactsView: View {
        var body: some View {
            // Your Contacts view content goes here
            Text("Contacts Content")
                .padding()
        }
    }

    struct SettingsView: View {
        var body: some View {
            // Your Settings view content goes here
            Text("Settings Content")
                .padding()
        }
    }
    
}

#Preview {
    ContentView()
}
