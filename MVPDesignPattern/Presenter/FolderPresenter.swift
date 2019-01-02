//
//  FolderPresenter.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2018/12/29.
//  Copyright © 2018 BearCookies. All rights reserved.
//

import Foundation
import UIKit

struct FolderState: State {
    var rootFolder: Folder
}

enum FolderAction: Action {
    case enterSubFolder(Folder)
}

class FolderPresenter: PresenterProtocol {
    
    // TODO - weak问题
    var rootViewController: UIViewController & StateSubscriber
    
    private var folderViewContrller: FolderViewController?
    private let folderModel: FolderModel
    
    // Redux
    var state: FolderState
    var subscribers = [StateSubscriber]()
    
    init(state: FolderState = FolderState(rootFolder: Store.shared.rootFolder)) {
        self.state = state
        self.folderModel = FolderModel(folder: state.rootFolder)
        
        let folderViewController = FolderViewController(folder: folderModel.rootFolder())
        self.rootViewController = folderViewController
        self.subscribe(folderViewController)
    }
    
    func dispatch(action: Action, state: State?) {
        if let folderState = reduce(action, state) as? FolderState {
            self.state = folderState
            subscribers.forEach { $0.newState(state: folderState) }
        }
    }
    
    private func reduce(_ action: Action, _ state: State?) -> State {
        let state = state ?? self.state
        
        if let action = action as? FolderAction {
            switch action {
            case .enterSubFolder(let folder):
                self.enterSubFolder(folder: folder)
            }
        }
        
        return state
    }
    
    private func subscribe(_ newSubscriber: StateSubscriber) {
        subscribers.append(newSubscriber)
    }
    
}

extension FolderPresenter {
    
    fileprivate func enterSubFolder(folder: Folder) {
        if let nav = self.rootViewController.navigationController {
            Router.routeTo(presenter: FolderPresenter(state: FolderState(rootFolder: folder)), with: nav)
        }
    }
    
}
