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
    var photoOperationsManager: PhotoListOperationManager {get}
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
        
        switch self.listItem.imageStatus {
            
        case .new:
            startImageDownload()
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            songImageView.image = UIImage(systemName: "music.note")
        case .downloaded:
            songImageView.image = listItem.image
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            startImageConversion()
            
        case .converted:
            songImageView.image = listItem.image
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        case .downloadFailed:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            songImageView.image = UIImage(systemName: "wrongwaysign")
        }
        
        
    }
    
    
    
    
    func startImageDownload() {
        guard delegate?.photoOperationsManager.downloadOperationInProgress[indexPath] == nil else {return}
        let downloadOperation = PhotoDownloadOperation(indexPath: indexPath, listItem: listItem)
        downloadOperation.completionBlock = {
            DispatchQueue.main.async {
                self.delegate?.photoOperationsManager.downloadOperationInProgress.removeValue(forKey: self.indexPath)
                self.delegate?.doBatchRowUpdates(indexPath: self.indexPath, listItem: self.listItem)
            }
        }
        
        delegate?.photoOperationsManager.downloadOperationInProgress[indexPath] = downloadOperation
        delegate?.photoOperationsManager.downLoadOperationQueue.addOperation(downloadOperation)
    }
    
    func startImageConversion() {
        guard delegate?.photoOperationsManager.conversionOperationInprogress[indexPath] == nil else {return}
        let conversionOperation = PhotoConversionOperation(photoItem: listItem, indexPath: self.indexPath)
        conversionOperation.completionBlock = {
            self.delegate?.photoOperationsManager.conversionOperationInprogress.removeValue(forKey: self.indexPath)
            self.delegate?.doBatchRowUpdates(indexPath: self.indexPath, listItem: self.listItem)
        }
    }
    
    
}
