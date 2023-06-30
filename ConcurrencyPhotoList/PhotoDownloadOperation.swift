//
//  PhotoDownloadOperation.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 30/06/23.
//

import Foundation
import UIKit


class PhotoDownloadOperation: Operation {
    var indexPath: IndexPath!
    var listItem: SongItem!
    
    init(indexPath:IndexPath, listItem: SongItem) {
        self.indexPath = indexPath
        self.listItem = listItem
    
    }
    
    override func main() {
        guard !isCancelled else {return}
        guard let urlStr = listItem.url, let url = URL(string: urlStr)  else {
            print("url string error")
            return
        }
        
        do{
           let data = try Data(contentsOf: url)
            guard !isCancelled else {return}
            let image = UIImage(data: data)
            listItem.image = image
            listItem.imageStatus = .downloaded
        }catch{
            guard !isCancelled else {return}
            listItem.imageStatus = .downloadFailed
        }


    }
}
