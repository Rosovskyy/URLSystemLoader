//
//  ViewController.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 04.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController {
    
    // MARK: - Properties
    let urlService = URLService()
    let pictureDownloadService = PictureDownloadService()
    let downloadLocationPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    var downloadSession: URLSession!
    
    var pictures = [Picture]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private
    private func setupUI() {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        // Session
        downloadSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: PictureLoaderCell.id, bundle: nil), forCellReuseIdentifier: PictureLoaderCell.id)
        
        // Data
        pictureDownloadService.session = downloadSession
        urlService.loadImagesData { [weak self] pictures in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.pictures = pictures
            self?.tableView.reloadData()
        }
    }
}
