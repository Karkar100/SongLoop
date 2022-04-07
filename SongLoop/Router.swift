//
//  Router.swift
//  SongLoop
//
//  Created by Diana Princess on 06.04.2022.
//
import UIKit

protocol RouterBasic {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: ModuleBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterBasic {
    func initialViewController()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleBuilder: ModuleBuilderProtocol?
    
    init(navigationController: UINavigationController, moduleBuilder: ModuleBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = moduleBuilder
    }
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = moduleBuilder?.buildMainScreen(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
}
