//
//  BaseViewController.swift
//  NetworkDemo
//
//  Created by Mehul on 17/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkManager.isUnreachable { (instance) in
            // If the network is reachable show the main controller
            self.showNoNetworkViewController()
        }

        network.reachability.whenUnreachable = { _ in
            self.showNoNetworkViewController()
        }
    }
    
    func showNoNetworkViewController() {
        DispatchQueue.main.async {
            let noNetworkVC = NoNetworkViewController.init(nibName: "NoNetworkViewController", bundle: nil)
            self.present(noNetworkVC, animated: false, completion: nil)
        }
    }
}
