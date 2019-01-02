//
//  FolderModel.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2018/12/29.
//  Copyright © 2018 BearCookies. All rights reserved.
//

import Foundation

class FolderModel {
    
    private let folder: Folder
    
    init(folder: Folder?) {
        self.folder = folder ?? Store.shared.rootFolder
    }
    
    public func rootFolder() -> Folder {
        return self.folder
    }
    
    public func subFolders() {
        
    }
    
}
