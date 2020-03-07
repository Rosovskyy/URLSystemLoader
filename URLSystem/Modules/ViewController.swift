//
//  ViewController.swift
//  URLSystem
//
//  Created by Serhii Rosovskyi on 04.03.2020.
//  Copyright © 2020 Serhii Rosovskyi. All rights reserved.
//

import UIKit
import MBProgressHUD
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let urlService = URLService()
    private let downloadLocationPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var downloadSession: URLSession!
    let pictureDownloadService = PictureDownloadService()
    
    var pictures = [Picture]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        prepareBind()
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
        urlService.loadImagesData()
    }
    
    private func prepareBind() {
        urlService.picturesGot.bind { [weak self] pictures in
            MBProgressHUD.hide(for: self!.view, animated: true)
            self?.pictures = pictures
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}
