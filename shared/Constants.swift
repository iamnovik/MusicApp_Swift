//
//  Constants.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//
import SwiftUI

struct TextInputDecoration: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
            )
    }
}

let textInputDecoration = TextInputDecoration()

let primaryColor = Color(red: 52/255, green: 86/255, blue: 139/255) // Основной синий
let secondaryColor = Color(red: 247/255, green: 197/255, blue: 159/255) // Персиковый
let accentColor = Color(red: 219/255, green: 84/255, blue: 97/255) // Коралловый
let backgroundColor = Color(red: 237/255, green: 237/255, blue: 237/255) // Светло-серый
let textColor = Color(red: 51/255, green: 51/255, blue: 51/255) // Темно-серый
let highlightColor = Color(red: 136/255, green: 176/255, blue: 75/255) // Желто-зеленый

enum MenuItem {
    case settings
    case logout
    case home
    case favourites
}

