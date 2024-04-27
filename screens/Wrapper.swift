//
//  Wrapper.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//
import SwiftUI
import Firebase
struct Wrapper: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    
    var body: some View {
        if authenticationService.currentUser == nil {
            Authentication()
        } else {
            //Text("Hello")
            Home()
        }
    }
}
