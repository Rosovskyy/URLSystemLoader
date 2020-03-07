//
//  URLService.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class URLService {
    
    // MARK: - Properties
    let session = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var pictures = [Picture]()
    
    // MARK: - Rx
    let picturesGot = PublishRelay<[Picture]>()
    
    // MARK: - Public
    func loadImagesData() {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=1&limit=99") else { return }
        dataTask = session.dataTask(with: url) { [weak self] data, response, error in
            defer {
              self?.dataTask = nil
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                self?.updateSearchResults(data)
                DispatchQueue.main.async {
                    self?.picturesGot.accept(self!.pictures)
                }
            }
        }
        dataTask?.resume()
    }
    
    // MARK: - Private
    private func updateSearchResults(_ data: Data) {
        var responseOpt: [Any]?
        pictures.removeAll()
      
        do {
            responseOpt = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch _ as NSError { return }
      
        guard let response = responseOpt else { return }
      
        var id = 0
        for pictureResponse in response {
            if let picture = pictureResponse as? [String: Any],
                let author = picture["author"] as? String,
                let width = picture["width"] as? Int,
                let height = picture["height"] as? Int,
                let url = picture["url"] as? String,
                let downloadUrl = picture["download_url"] as? String {
                let picture = Picture(id: id, author: author, width: width, height: height, url: url, downloadUrl: downloadUrl)
                pictures.append(picture)
                id += 1
            }
        }
    }
}
