//
//  PhotoListOperationManager.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 30/06/23.
//

import Foundation


class PhotoListOperationManager {
    lazy var downloadOperationInProgress: [IndexPath: Operation] = [:]
    lazy var downLoadOperationQueue : OperationQueue = {
        let operationQueue = OperationQueue()
        operationQueue.name = "com.downloadOperation.con"
        return operationQueue
    }()
    
}
