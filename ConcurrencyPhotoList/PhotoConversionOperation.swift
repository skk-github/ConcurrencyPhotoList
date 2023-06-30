//
//  PhotoConversionOperation.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 30/06/23.
//

import Foundation
import UIKit


class PhotoConversionOperation: Operation {
    
    var photoItem: SongItem
    var indexPath: IndexPath
    
    init(photoItem: SongItem, indexPath: IndexPath) {
        self.photoItem = photoItem
        self.indexPath = indexPath
    }
    
    override func main() {
        guard !isCancelled else {return}
        guard photoItem.imageStatus == .downloaded else {return}
        changeToPng(image: photoItem.image)
            
        
    }
    
    func changeToPng(image: UIImage?) {
        guard let unwrappedImage = image else {
            return
        }
        
        if let pngData = unwrappedImage.pngData() {
            guard let pngImage = UIImage(data: pngData) else {return}
            guard !isCancelled else {return}
            photoItem.imageStatus = .converted
            photoItem.image = pngImage
        }
    }
    
}
