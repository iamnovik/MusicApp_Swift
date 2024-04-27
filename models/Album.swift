//
//  Album.swift
//  music_app
//
//  Created by Novik Vladislav on 18.04.24.
//

import Foundation

class Album{
    let uid: String
    let title: String
    let artist: String
    let year: Int
    var isFav: Bool = false

    init(uid: String, title: String, artist: String, year: Int) {
        self.uid = uid
        self.title = title
        self.artist = artist
        self.year = year
    }
}
