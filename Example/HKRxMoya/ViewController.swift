//
//  ViewController.swift
//  HKRxMoya
//
//  Created by oragekk@163.com on 02/10/2023.
//  Copyright (c) 2023 oragekk@163.com. All rights reserved.
//

import UIKit
import HKRxMoya
import RxSwift

class ViewController: UIViewController {
    private lazy var disposeBag:DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Networking.request(TestAPI.weather(address: "上海"))
            .mapModel(Weather.self)
            .subscribe(onNext: {data in
                if let lives  = data.lives {
                    for live in lives {
                        print(live.weather!)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

