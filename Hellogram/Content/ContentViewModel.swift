//
//  ContentViewModel.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 18/11/23.
//

import Foundation
import TDLibKit

class ContentViewModel: ObservableObject {
    
    @Published var loggedIn = true
    @Published var phone = ""
    @Published var code = ""
    @Published var twofa = ""
    @Published var hint = ""
    @Published var chats = [Chat]()
    @Published var filteredChats = [Chat]()
    
    init() {
        setPublishers()
    }
    
    func setPublishers() {
        nc.publisher(for: .waitPassword) { _ in
            hint = "waitPassword"
        }
        
        nc.publisher(for: .waitCode) { _ in
            hint = "waitCode"
        }
        
        nc.mergeMany([
            nc.publisher(for: .waitPhoneNumber),
            nc.publisher(for: .closed),
            nc.publisher(for: .closing),
            nc.publisher(for: .loggingOut)
        ]) { _ in
            hint = "waitPhoneNumber (or restart app)"
        }
        
        nc.mergeMany([.closed, .closing, .loggingOut, .waitPhoneNumber, .waitCode, .waitPassword]) { _ in
            Task.main {
                loggedIn = false
            }
        }
        
        nc.publisher(for: .ready) { _ in
            Task.main {
                loggedIn = true
                try await loadChats()
            }
        }
        
        nc.publisher(for: .newMessage){ _ in
            Task.main {
                try await loadChats()
            }
        }
    }
    
    @MainActor func loadChats() async throws {
        let chatIds = try await tdApi.getChats(chatList: .chatListMain, limit: 200).chatIds
        let chats = try await chatIds.asyncCompactMap { try await tdApi.getChat(chatId: $0) }
        self.chats = chats
        self.filteredChats = chats
    }
    
    func submit() async throws {
        switch try await tdApi.getAuthorizationState() {
            case .authorizationStateWaitPhoneNumber:
                _ = try await tdApi.setAuthenticationPhoneNumber(phoneNumber: phone, settings: nil)
            case .authorizationStateWaitCode:
                _ = try await tdApi.checkAuthenticationCode(code: code)
            case .authorizationStateWaitPassword:
                _ = try await tdApi.checkAuthenticationPassword(password: twofa)
            default:
                break
        }
    }
    
    func filterChats(searchText: String){
        if searchText.isEmpty {
            filteredChats = chats
        } else {
            filteredChats = chats.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
    
}
