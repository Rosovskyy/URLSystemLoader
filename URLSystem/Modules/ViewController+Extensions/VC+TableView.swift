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
        cell.configureCell(selectedSection: selectedSection)
        
        if let progress = pictureDownloadService.activeDownloads[URL(string: picture.downloadUrl)!]?.progress {
            cell.progressLabel.text = "\(Int(round(progress*100)))%"
            cell.progressView.progress = progress
        }
        
        cell.selectionStyle = .none
                
        cell.startLoading.bind {
            self.pictureDownloadService.startPictureDownload(picture: picture)
            self.inProgressPictures.append(picture)
            for (ind, pict) in self.toDoPictures.enumerated() {
                if pict.id == picture.id {
                    self.toDoPictures.remove(at: ind)
                    self.pictures.remove(at: ind)
                    self.tableView.deleteRows(at: [IndexPath(row: ind, section: 0)], with: .automatic)
                    break
                }
            }
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var picture: Picture?
            if selectedSection == .inProgress {
                picture = inProgressPictures[indexPath.row]
                inProgressPictures.remove(at: indexPath.row)
            } else if selectedSection == .done {
                picture = donePictures[indexPath.row]
                donePictures.remove(at: indexPath.row)
            }
            pictureDownloadService.activeDownloads[URL(string: picture!.downloadUrl)!]?.task?.cancel()
            pictureDownloadService.activeDownloads.removeValue(forKey: URL(string: picture! .downloadUrl)!)
            pictures.remove(at: indexPath.row)
            if tableView.numberOfRows(inSection: 0) >= indexPath.row {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else {
            return
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if selectedSection != .toDo {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedSection == .done {
            let picture = donePictures[indexPath.row]
            blurEffectView.isHidden = false
            cellImageView.image = picture.image
            cellImagePreView.isHidden = false
            view.bringSubviewToFront(cellImagePreView)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
