//
//  User.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//

import Foundation

class User: Identifiable {
    let uid: String
    
    init(uid: String) {
        self.uid = uid
    }
}

class UserData: ObservableObject {
    var id = UUID()
    var uid: String
    @Published var firstname: String
    @Published var secondname: String
    @Published var birthdate: Date
    @Published var sex: Bool
    @Published var address: String
    @Published var image: String
    @Published var favalbum: String
    @Published var favartist: String
    @Published var about: String
    @Published var favAlbums: [String]
    
    init(uid: String,
         firstname: String = "",
         secondname: String = "",
         birthdate: Date = Date(),
         sex: Bool = false,
         address: String = "",
         image: String = "",
         favalbum: String = "",
         favartist: String = "",
         about: String = "",
         favAlbums: [String] = []) {
        self.uid = uid
        self.firstname = firstname
        self.secondname = secondname
        self.birthdate = birthdate
        self.sex = sex
        self.address = address
        self.image = image
        self.favalbum = favalbum
        self.favartist = favartist
        self.about = about
        self.favAlbums = favAlbums
    }
}
