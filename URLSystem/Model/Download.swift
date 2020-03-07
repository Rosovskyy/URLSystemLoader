//
//  Download.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation

class Download: NSObject {
    
    // MARK: - Properties
    var isDownloading = false
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var picture: Picture?
    
    // MARK: - Initialization
    init(picture: Picture) {
        self.picture = picture
    }
}
