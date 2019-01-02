//
//  ViewController.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2018/12/29.
//  Copyright © 2018 BearCookies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func push(_ sender: Any) {
        if let nav = self.navigationController {
            Router.routeTo(presenter: FolderPresenter(rootFolder: nil), with: nav)
        }
    }
    
}

