//
//  ViewController.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 28/06/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageListTableView: UITableView!
    
    
    
    var imageListArray: [SongItem] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageListTableView.dataSource = self
        imageListTableView.delegate = self
        
        
        fetchImageList()
        
    }
    
    
    func fetchImageList() {
        
        NetworkManager().getList { [weak self] result in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    fatalError("self fail")
                }
                switch result{
                    
                case .success(let list):
                    list.forEach{ item in
                        let songItem = SongItem(songElement: item)
                        self.imageListArray.append(songItem)
                    }
                    print(list.count, self.imageListArray.count)
                    self.imageListTableView.reloadData()
                case .failure(let err):
                    print(err.description)
                }
            }
            
            
        }
        
        
    }


}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
        
        cell.setDetails(listItem: &imageListArray[indexPath.row])
        
        return cell
    }
    
    
}

