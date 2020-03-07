//
//  PictureDownloadService.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import Foundation

class PictureDownloadService {
    
    // MARK: - Properties
    var session: URLSession!
    var activeDownloads = [URL: Download]()
    
    // MARK: - Public
    func startPictureDownload(picture: Picture) {
        guard let url = URL(string: picture.downloadUrl) else { return }
        let pictureDownload = Download(picture: picture)
        pictureDownload.isDownloading = true
        pictureDownload.task = session.downloadTask(with: url)
        pictureDownload.task?.resume()
        activeDownloads[url] = pictureDownload
    }
    
    func pauseDownload(picture: Picture) {
        guard let download = activeDownloads[URL(string: picture.downloadUrl)!], download.isDownloading else { return}
      
      download.task?.cancel(byProducingResumeData: { data in
        download.resumeData = data
      })

      download.isDownloading = false
    }
    
    func resumeDownload(picture: Picture) {
        guard let download = activeDownloads[URL(string: picture.downloadUrl)!] else { return }
      
        if let resumeData = download.resumeData {
            download.task = session.downloadTask(withResumeData: resumeData)
        } else {
            download.task = session.downloadTask(with: URL(string: download.picture?.downloadUrl ?? "")!)
        }
      
        download.task?.resume()
        download.isDownloading = true
    }
    
    func cancelDownload(picture: Picture) {
        guard let download = activeDownloads[URL(string: picture.downloadUrl)!] else {
          return
        }
        download.task?.cancel()

        activeDownloads[URL(string: picture.downloadUrl)!] = nil
    }
}
