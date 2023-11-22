//
//  HellogramApp.swift
//  Hellogram
//
//  Created by Gayrat Rakhimov on 14/11/23.
//
import SwiftUI
import TDLibKit

@main
struct HellogramApp: App {
    
    init() {
        TdApi.shared.startTdLibUpdateHandler()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
