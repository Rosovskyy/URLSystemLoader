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
    private var backgroundDownloadSession: URLSession!
    var selectedSection = SelectedSection.toDo
    let pictureDownloadService = PictureDownloadService()
    
    var pictures = [Picture]()
    var toDoPictures = [Picture]()
    var inProgressPictures = [Picture]()
    var donePictures = [Picture]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        prepareBind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Private
    private func setupUI() {
        
        MBProgressHUD.showAdded(to: view, animated: true)
        
        // Session
        downloadSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        backgroundDownloadSession = URLSession(configuration: .background(withIdentifier: "MyBackgroundSession"), delegate: self, delegateQueue: nil)
        
        // Segment View
        
        
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
            self?.toDoPictures = pictures
            self?.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Actions
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentView.selectedSegmentIndex {
        case 0:
            pictures = toDoPictures
            selectedSection = .toDo
            tableView.reloadData()
        case 1:
            pictures = inProgressPictures
            selectedSection = .inProgress
            tableView.reloadData()
        case 2:
            pictures = donePictures
            selectedSection = .done
            tableView.reloadData()
        default:
            break
        }
    }
    
    @objc func closeActivityController()  {

    }

    @objc func openactivity()  {

    }
}
