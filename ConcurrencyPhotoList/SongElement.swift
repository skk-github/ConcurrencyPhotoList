//
//  SongElement.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 28/06/23.
//

import UIKit




struct SongElement: Codable {
    let id: Int
    let albumID: Int?
    let title: String
    let url, thumbnailURL: String?
    
}


class SongItem {
    enum ImageStatus {
        case new, downloaded, converted, downloadFailed
    }
    var id: Int
    var title: String
    var albumID: Int?
    var url, thumbnailURL: String?
    var image: UIImage? = nil
    var imageStatus: ImageStatus
   
    
    init(songElement: SongElement) {
        self.albumID = songElement.albumID
        self.id = songElement.id
        self.title = songElement.title
        self.url = songElement.url
        self.thumbnailURL = songElement.thumbnailURL
        self.imageStatus = .new
    }
}
