//
//  VC+TableView.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 07.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PictureLoaderCell.id, for: indexPath) as! PictureLoaderCell
        
        let picture = pictures[indexPath.row]
        cell.picture = picture
        cell.configureCell(downloaded: picture.loadingFinished ?? false, download: pictureDownloadService.activeDownloads[URL(string: picture.downloadUrl)!])
                
        cell.startLoading.bind {
            self.pictureDownloadService.startPictureDownload(picture: picture)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }.disposed(by: cell.disposeBag)

        cell.pauseLoading.bind {
            self.pictureDownloadService.pauseDownload(picture: picture)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }.disposed(by: cell.disposeBag)
        
        cell.resumeLoading.bind {
            self.pictureDownloadService.resumeDownload(picture: picture)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }.disposed(by: cell.disposeBag)
        
        cell.deleteImage.bind {
            self.pictureDownloadService.cancelDownload(picture: picture)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }.disposed(by: cell.disposeBag)
        
        return cell
    }
}
