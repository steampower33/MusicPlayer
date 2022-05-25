//
//  Album.swift
//  SpotifyClone
//
//  Created by SeungMin Lee on 2022/05/24.
//

import Foundation

struct Album {
    var name: String
    var image: String
    var songs: [Song]
}

extension Album {
    static func get() -> [Album] {
        return [
            Album(name: "Songs", image: "Bruno Mars", songs: [
                Song(name: "24K Magic", image: "Bruno Mars", artist: "Bruno Mars", fileName: "24K Magic"),
                Song(name: "Thats What I Like", image: "Bruno Mars", artist: "Bruno Mars", fileName: "Thats What I Like"),
                Song(name: "The Lazy Song", image: "Bruno Mars", artist: "Bruno Mars", fileName: "The Lazy Song"),
            ]),
        ]
    }
}
