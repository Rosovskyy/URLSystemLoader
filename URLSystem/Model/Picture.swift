//
//  Picture.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation
import UIKit

class Picture: NSObject {
    
    // MARK: - Properties
    let id: Int
    let author: String
    let width: Int
    let height: Int
    let url: String
    let downloadUrl: String
    var image: UIImage?
    
    var loadingFinished: Bool?
    
    // MARK: - Initialization
    init(id: Int, author: String, width: Int, height: Int, url: String, downloadUrl: String) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.downloadUrl = downloadUrl
        
        loadingFinished = false
    }
}
