//
//  FolderPresenter.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2018/12/29.
//  Copyright © 2018 BearCookies. All rights reserved.
//

import Foundation
import UIKit

enum FolderState: PresenterStateProtocol {
    case folder(Folder?)
}

class FolderPresenter: PresenterProtocol {
    
    var rootViewController: UIViewController
    
//    private let state: FolderState
    private var folderViewContrller: FolderViewController?
    private let folderModel: FolderModel
    
    init(rootFolder: Folder? = nil) {
        self.folderModel = FolderModel(folder: rootFolder)
        self.rootViewController = FolderViewController(folder: folderModel.rootFolder())
    }
    
}

extension FolderPresenter {
    
    func enterSubFolder(folder: Folder) {
        if let nav = self.rootViewController.navigationController {
            Router.routeTo(presenter: FolderPresenter(rootFolder: folder), with: nav)
        }
    }
    
}
