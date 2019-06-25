//
//  ViewController.swift
//  Promise
//
//  Created by Grigoriy Sapogov on 25/06/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit
import PromiseKit
import Moya

class ViewController: UIViewController {
    
    let provider = MoyaProvider<MyService>()
    
    func fetchEmployees(completion: @escaping ([Employee]?, Error?) -> Void) {
        
        provider.request(.employees) { result in
            
            switch result {
                
            case let .success(response):
                let employess = try? JSONDecoder().decode([Employee].self, from: response.data)
                completion(employess, nil)
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func promiseFetchEmployees() -> Promise<[Employee]> {
        
        return Promise { seal in
            fetchEmployees(completion: { (employees, error) in
                seal.resolve(employees, error)
            })
        }
    }
    
    func promiseArray() -> Promise<[Employee]> {
        
        return Promise { seal in
            provider.request(.employees) { result in
            
                switch result {

                case let .success(response):
                    
                    
                    do {
                        let employess = try JSONDecoder().decode([Employee].self, from: response.data)
                        seal.resolve(employess, nil)
                    }
                    catch let error {
                        seal.reject(error)
                    }
                case let .failure(error):
                    let myError = NSError(domain: "api", code: 1, userInfo: nil)
                    seal.reject(myError)
                }
            }
        }
    }
    
    @IBAction func actionPress(_ sender: Any) {
        
        firstly {
            promiseArray()
        }.done { array in
            print(array)
        }.catch { error in
            print(error)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

