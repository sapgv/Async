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
    
    func fetchEmployee(_ id: String, completion: @escaping (Employee?, Error?) -> Void) {

        var delay: Double = 0
        if id == "75748" {
            delay = 15
        }
        else {
            delay = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.provider.request(.employee(id)) { result in
                
                switch result {
                case let .success(response):
                    do {
                        let employee = try JSONDecoder().decode(Employee.self, from: response.data)
                        completion(employee, nil)
                    }
                    catch let error {
                        completion(nil, error)
                    }
                case let .failure(error):
                    completion(nil, error)
                }
            }
        }
        
    }
    
    func fetchEmployees(completion: @escaping ([Employee]?, Error?) -> Void) {
        
        provider.request(.employees) { result in
            switch result {
            case let .success(response):
                do {
                    let employess = try JSONDecoder().decode([Employee].self, from: response.data)
                    completion(employess, nil)
                }
                catch let error {
                     completion(nil, error)
                }
            case let .failure(error):
                completion(nil, error)
            }
        }
    }
    
    func promiseEmployee(_ id: String) -> Promise<Employee> {
    
        return Promise {
            fetchEmployee(id, completion: $0.resolve)
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
                case let .failure(_):
                    let myError = NSError(domain: "api", code: 1, userInfo: nil)
                    seal.reject(myError)
                }
            }
        }
    }
    
    func promiseShort() -> Promise<[Employee]> {
        return Promise {
            fetchEmployees(completion: $0.resolve)
        }
    }
    
    @IBAction func actionPress(_ sender: Any) {
        
        firstly {
            promiseShort()
        }.done { array in
            print(array)
        }.catch { error in
            print(error)
        }
        
        
    }
    
    @IBAction func actionGroup(_ sender: Any) {
        
        let empl_73558 = promiseEmployee("75748")
        let empl_73564 = promiseEmployee("75749")
        
        firstly {
            when(fulfilled: empl_73558, empl_73564)
        }.done { em1, em2 in
            
            print("em1 \(em1)")
            print("em2 \(em2)")
                
        }.catch { error in
                print(error)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

