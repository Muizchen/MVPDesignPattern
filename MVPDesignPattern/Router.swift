//
//  Router.swift
//  MVPDesignPattern
//
//  Created by Muiz on 2019/1/1.
//  Copyright © 2019 BearCookies. All rights reserved.
//

import Foundation
import UIKit

protocol PresenterProtocol {
    var rootViewController: UIViewController { get }
}

protocol RootViewControllerProtocol {
    var presenter: PresenterStateProtocol { get }
}

protocol PresenterStateProtocol {
    
}

class Router {
    
    class func routeTo(presenter: PresenterProtocol, with nav: UINavigationController) {
        if let vc = presenter.rootViewController as? FolderViewController, let presenter = presenter as? FolderPresenter {
            vc.presenter = presenter
        }
        nav.pushViewController(presenter.rootViewController, animated: true)
    }
    
}
