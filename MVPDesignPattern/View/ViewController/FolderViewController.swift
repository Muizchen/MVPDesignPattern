//
//  FolderViewController.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2018/12/29.
//  Copyright © 2018 BearCookies. All rights reserved.
//

import UIKit

enum ExcuteCMD {
    case enterSubFolder(Folder)
}

class FolderViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var presenter: FolderPresenter?
    private var folder: Folder! {
        didSet {
            self.refreshData()
        }
    }
    
    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: String(describing: FolderViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let createNewFolderButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(createNewFolder))
        let createNewRecordingButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewRecording))
        self.navigationItem.rightBarButtonItems = [createNewRecordingButton, createNewFolderButton]
        
        NotificationCenter.default.addObserver(forName: Store.changedNotification, object: nil, queue: OperationQueue.main) { _ in
            self.tableView.reloadData()
        }
        
        tableView.register(UINib(nibName: .folderCellIdentifier, bundle: nil), forCellReuseIdentifier: .folderCellIdentifier)
        tableView.register(UINib(nibName: .recordingCellIdentifier, bundle: nil), forCellReuseIdentifier: .recordingCellIdentifier)
        
        self.title = folder === Store.shared.rootFolder ? .recordings : folder.name
    }
    
}

extension FolderViewController {
    
    private func refreshData() {
        self.title = folder === Store.shared.rootFolder ? .recordings : folder.name
        self.tableView.reloadData()
    }
    
    @objc public func createNewFolder() {
        modalTextAlert(title: .createFolder, placeholder: .folderName) { (name) in
            if let name = name {
                let folder = Folder.init(name: name, uuid: UUID())
                self.folder.add(folder)
            }
        }
    }
    
    @objc public func createNewRecording() {
        
    }
    
}

// 订阅State
extension FolderViewController: StateSubscriber {
    
    func newState(state: State) {
        if let folderState = state as? FolderState {
            self.folder = folderState.rootFolder
        }
    }
    
}

extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folder.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = folder.contents[indexPath.row]
        let identifier: String = item is Folder ? .folderCellIdentifier : .recordingCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "\(item is Folder ? String.folderEmoji : String.recordingEmoji) \(item.name)"
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            folder.remove(folder.contents[indexPath.row])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = folder.contents[indexPath.row]
        if let folder = item as? Folder, let presenter = self.presenter {
            presenter.dispatch(action: FolderAction.enterSubFolder(folder), state: nil)
        } else {
            
        }
    }
    
}

fileprivate extension String {
    static let uuidPathKey = "uuidPath"
    static let showRecorder = "showRecorder"
    static let showPlayer = "showPlayer"
    static let showFolder = "showFolder"
    
    static let recordings = NSLocalizedString("Recordings", comment: "Heading for the list of recorded audio items and folders.")
    static let createFolder = NSLocalizedString("Create Folder", comment: "Header for folder creation dialog")
    static let folderName = NSLocalizedString("Folder Name", comment: "Placeholder for text field where folder name should be entered.")
    static let create = NSLocalizedString("Create", comment: "Confirm button for folder creation dialog")
    
    static let folderEmoji = "📁"
    static let recordingEmoji = "🔊"
    
    static let folderCellIdentifier = "FolderCell"
    static let recordingCellIdentifier = "RecordingCell"
}
