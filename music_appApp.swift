//
//  music_appApp.swift
//  music_app
//
//  Created by Novik Vladislav on 17.04.24.
//

import SwiftUI
import Firebase

@main
struct music_app: App {
    @StateObject var authenticationService = AuthenticationService()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationService)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        Wrapper()
    }
}
