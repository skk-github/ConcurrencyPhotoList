//
//  NetworkManager.swift
//  ConcurrencyPhotoList
//
//  Created by Krishna on 28/06/23.
//

import Foundation

enum APIErrors: Error, CustomStringConvertible {
    
    
    case badUrl
    case urlsessionError
    case responseError
    case decodingError
    case otherError(String?)
    
    var description: String{
        switch self {
            
        case .badUrl:
            return "badUrl"
        case .responseError:
            return "resp err"
        case .decodingError:
            return "decoding err"
        case .urlsessionError:
            return "url session error"
        case .otherError(let val):
            return "other err: \(String(describing: val))"
        }
    }
}


class NetworkManager {
    
    
    
    func getList(completion: @escaping(Result<[SongElement],APIErrors>)-> Void)  {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            completion(.failure(APIErrors.badUrl))
            return}
        
         let urlReq = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { data, resp, err in
            if let err = err {
                completion(.failure(APIErrors.urlsessionError))
            }
            if let resp = resp as? HTTPURLResponse, !(200...299).contains(resp.statusCode){
                completion(.failure(APIErrors.responseError))
            }
            guard let unwrappedData = data else {
                completion(.failure(APIErrors.otherError("data unwrap failed")))
                return
            }
            let decoder = JSONDecoder()
            do {
                let fetchedList = try decoder.decode([SongElement].self, from: unwrappedData)
                
                completion(.success(fetchedList))
            }catch{
                completion(.failure(APIErrors.decodingError))
            }
            
        }
        
        dataTask.resume()
        
    }
}
