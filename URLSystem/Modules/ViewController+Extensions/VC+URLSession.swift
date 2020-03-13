//
//  VC+URLSession.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        
        let download = pictureDownloadService.activeDownloads[sourceURL]
        pictureDownloadService.activeDownloads[sourceURL] = nil
        
        download?.picture?.loadingFinished = true
        
        if let data = try? Data(contentsOf: location), let index = download?.picture?.id {
            let image = UIImage(data: data)
            for (ind, pict) in pictures.enumerated() {
                if index == pict.id {
                    pictures.remove(at: ind)
                    break
                }
            }
            for (ind, pict) in inProgressPictures.enumerated() {
                if index == pict.id {
                    inProgressPictures[ind].image = image
                    donePictures.append(inProgressPictures[ind])
                    inProgressPictures.remove(at: ind)
                    DispatchQueue.main.async {
                        switch self.selectedSection {
                        case .inProgress:
                            self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                        case .done:
                            self.tableView.reloadData()
                        default:
                            break
                        }
                    }
                    break
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let url = downloadTask.originalRequest?.url, let download = pictureDownloadService.activeDownloads[url] else { return }
        
        download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            if self.selectedSection == .inProgress {
                for (ind, pict) in self.inProgressPictures.enumerated() {
                    if pict.id == download.picture?.id, let pictureLoaderCell = self.tableView.cellForRow(at: IndexPath(row: ind, section: 0)) as? PictureLoaderCell {
                        pictureLoaderCell.progressLabel.text = "\(Int(round(download.progress*100)))%"
                        break
                    }
                }
            }
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let backgroundCompletionHandler =
                appDelegate.backgroundCompletionHandler else {
                    return
            }
            backgroundCompletionHandler()
        }
    }
}
