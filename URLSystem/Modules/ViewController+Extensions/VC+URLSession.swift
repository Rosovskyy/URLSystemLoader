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
                    pictures[ind].image = image
                    donePictures.append(pictures[ind])
                    pictures.remove(at: ind)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                    }
                }
            }
            
            for (ind, pict) in inProgressPictures.enumerated() {
                if index == pict.id {
                    inProgressPictures.remove(at: ind)
                    break
                }
            }
//            pictures[index].image = image
        }
        
//        if let index = download?.picture?.id {
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
//            }
//        }
    }
}
