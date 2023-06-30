//
//  ImageListCell.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 29/06/23.
//

import Foundation
import UIKit

protocol ImageListCellDelegate: AnyObject {
    func doBatchRowUpdates(indexPath: IndexPath, listItem: SongItem)
}


class ImageListCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var indexPath: IndexPath!
    var listItem: SongItem!
    
    weak var delegate: ImageListCellDelegate?
    
    
    func setDetails(listItem: SongItem, indexPath: IndexPath) {
        titleLabel.text = listItem.title
        self.indexPath = indexPath
        self.listItem = listItem
        if let image = listItem.image {
            songImageView.image = image
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
        }else{
            
            
            
            
            
            
            
            guard let urlStr = listItem.url  else {
                print("url string error")
                return
            }
            NetworkManager().downloadImage(imageURLStr: urlStr) {[weak self] result in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let image):
                        self.listItem.image = self.changeToPng(image: image)
                        self.songImageView.image = listItem.image
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        self.delegate?.doBatchRowUpdates(indexPath: self.indexPath, listItem: self.listItem)
                    case .failure(_):
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                    }
                }
            }
            
            
            
        }
        
    }
    
    
    func changeToPng(image: UIImage?) -> UIImage? {
        guard let unwrappedImage = image else {
            return image
        }
        
        if let pngData = unwrappedImage.pngData() {
            return UIImage(data: pngData)
        }
        return image
    }
    
    
}
