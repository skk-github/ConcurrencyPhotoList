//
//  ImageListCell.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 29/06/23.
//

import Foundation
import UIKit


class ImageListCell: UITableViewCell {
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    func setDetails(listItem: inout SongItem) {
        titleLabel.text = listItem.title
        if let image = listItem.image {
            songImageView.image = image
            
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            
        }else{
            guard let url = URL(string: listItem.url ?? "") else {
                print("url error")
                return
            }
            do{
                let imageData = try Data(contentsOf: url)
                
                let pngData =  UIImage(data: imageData)?.pngData()
                if let unwrappedPngData = pngData {
                    listItem.image = UIImage(data: unwrappedPngData)
                    songImageView.image = listItem.image
                }
                
                
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }catch{
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            }
            
            
        }
        
    }
    
    
}
