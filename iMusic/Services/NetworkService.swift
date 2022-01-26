//
//  NetworkService.swift
//  iMusic
//
//  Created by CodergirlTM on 18.01.22.
//

import UIKit
import Alamofire

class NetworkService {
    func fetchTracks(searchText: String, competion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search?term=\(searchText)"
        let parameters = ["term": "\(searchText)",
                          "limit" : "10",
                          "media" : "music"]
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let error = dataResponse.error {
                print("error received requesting data: \(error.localizedDescription)")
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects", objects)
                competion(objects)

            } catch let jsonError{
                print("failed to decode JSON", jsonError)
                competion(nil)
            }
        }
        
    }
}
