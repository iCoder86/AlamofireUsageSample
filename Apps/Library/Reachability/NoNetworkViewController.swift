//
//  NoNetworkViewController.swift
//  NetworkDemo
//
//  Created by Mehul on 17/10/18.
//  Copyright © 2018 Mehul. All rights reserved.
//

import UIKit

class NoNetworkViewController: UIViewController {

    let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // If the network is reachable show the main controller
        network.reachability.whenReachable = { _ in
            self.dismissNoNetworkVC()
        }
    }
    
    @IBAction func checkReachabilityAction(_ sender: Any) {
        NetworkManager.isReachable { (instance) in
            // If the network is reachable show the main controller
            self.dismissNoNetworkVC()
        }
    }
    
    private func dismissNoNetworkVC() -> Void {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                
            })
        }
    }
}
