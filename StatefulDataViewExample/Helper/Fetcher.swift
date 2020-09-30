//
//  Fetcher.swift
//  StatefulDataViewExample
//
//  Created by Sinar Nirmata on 30/09/20.
//  Copyright © 2020 Sinar Nirmata. All rights reserved.
//

import Foundation

class Fetcher {
    private let session = URLSession.shared
    private var urlString = "https://www.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    var items: [Photo] = []
    
    func execute(completion: @escaping (([Photo]?) -> Void)) {
        let task = session.dataTask(with: URL(string: urlString)!, completionHandler: { data, response, error in
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                NSLog("Fetcher Error:: Status code doesn't fall inside success range")
                completion(nil)
                return
            }
            do {
                guard let data = data,
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let items = json["items"] as? [[String: Any]] else {
                        completion(nil)
                        return
                }
                
                self.items = items.map({ (obj) -> Photo in
                    return Photo(
                        author: obj["author"] as? String,
                        authorId: obj["author_id"] as? String,
                        dateTaken: obj["date_taken"] as? String,
                        description: obj["description"] as? String,
                        media: (obj["media"] as? [String: Any])?["m"] as? String,
                        title: obj["title"] as? String)
                })
                
                completion(self.items)
            } catch {
                NSLog("Fetcher Error:: \(error.localizedDescription)")
                completion(nil)
            }
        })
        
        task.resume()
    }
}

