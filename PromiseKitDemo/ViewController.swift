//
//  ViewController.swift
//  PromiseKitDemo
//
//  Created by 王大吉 on 7/8/18.
//  Copyright © 2018年 王大吉. All rights reserved.
//

import UIKit
import PromiseKit
import Alamofire
import SwiftyJSON

let url = "https://jsonplaceholder.typicode.com/posts"
let result = arc4random()%2 == 1
//let result = false
//let result = true

enum HttpError : Error{
    case networkError
    case downloadUserInfoError
    case updateUserInfoError
    case decoderJSONError
}

enum HttpFailureResult {
    case networkError
    case checkNetworkError
    case checkServerNetworkError
    case downloadUserInfoError
    case updateUserInfoError
    case decoderJSONError
}

enum HttpResult<T> {
    typealias U = T
    
    case success(U)
    case failure(HttpFailureResult)
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* 使用闭包的方式
        checkNetwork { (result) in
            self.updateUserInfo(block: { (result) in
                self.downloadUserInfo(block: { (result) in
                    self.decoderJSON(block: { (result) in
                        
                    })
                })
            })
        }
         */
 
        /*
         1、检测网络是否正常
         2、根据手机号码登录获取token
         3、获取用户的数据
         4、解析用户的数据
        */
        
        var params = (checkNetwork: false, token: "" , json: "")
        
        firstly {
            self.checkNetwork()
        }.then { (bool) -> Promise<String> in
            params.checkNetwork = bool
            return self.updateUserInfo()
        }.then { (token) -> Promise<[String: Any]> in
            params.token = token // 将token数据保存下来
            return self.downloadUserInfo()
        }.then { (json) -> Promise<UserModel> in
            print(params.token) // 使用token数据
            return self.decoderJSON()
        }.done { (userModel) in
            print("done")
        }.ensure {
            print("ensure")
        }.catch { (error) in
            print("error")
        }.finally {
            print("finally")
        }
 
        
        
        
        
        /*
         1、检测网络是否正常 && 检测服务器是否挂了
         2、根据手机号码登录获取token
         3、获取用户的数据
         4、解析用户的数据
         */
        
        var params1 = (checkNetwork: false, token: "" , json: "")
        
        firstly {
                when(resolved: self.checkNetwork(),
                     self.checkServerNetwork())
            }.then { (bool) -> Promise<String> in
//                params.checkNetwork = bool.
                return self.updateUserInfo()
            }.then { (token) -> Promise<[String: Any]> in
//                params.token = token
                return self.downloadUserInfo()
            }.then { (json) -> Promise<UserModel> in
                return self.decoderJSON()
            }.ensure {
                print("ensure")
            }.done { (userModel) in
                print("done")
            }.catch { (error) in
                print("error")
            }.finally {
                print("finally")
        }
        
    }

}


// 使用闭包的方式
extension ViewController {
    
    // 1、检测网络是否正常
    func checkNetwork(block: @escaping (HttpResult<Bool>)->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if result {
                block(.success(true))
            } else {
                block(.failure(.checkNetworkError))
            }
            print(#function)
        })
    }
    
    // 1.1、检测服务器是否挂了
    func checkServerNetwork(block: @escaping (HttpResult<Bool>)->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if result {
                block(.success(true))
            } else {
                block(.failure(.checkServerNetworkError))
            }
            print(#function)
        })
    }
    
    // 2、根据手机号码登录获取token
    func updateUserInfo(block: @escaping (HttpResult<String>)->()) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if result {
                block(.success("token - 10086"))
            } else {
                block(.failure(.updateUserInfoError))
            }
            print(#function)
        })
    }
    
    // 3、获取用户的数据
    func downloadUserInfo(block: @escaping (HttpResult<[String: Any]>)->()) {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if result {
                block(.success(["name": "wangdaji", "age": 25]))
            } else {
                block(.failure(.downloadUserInfoError))
            }
            print(#function)
        })
    }
    
    // 4、解析用户的数据
    func decoderJSON(block: @escaping (HttpResult<UserModel>)->()) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
            if result {
                block(.success(UserModel(name: "wangdaji", age: 26)))
            } else {
                block(.failure(.decoderJSONError))
            }
            print(#function)
        })
    }
}

// PromiseKit
extension ViewController {
    
    // 1、检测网络是否正常
    func checkNetwork() -> Promise<Bool> {
        
        return Promise.init(resolver: { (res) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                
                if result {
                    res.fulfill(true)
                } else {
                    res.reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    // 1.1、检测服务器是否挂了
    func checkServerNetwork() -> Promise<Bool> {
        
        return Promise.init(resolver: { (res) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                
                if result {
                    res.fulfill(true)
                } else {
                    res.reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    // 2、根据手机号码登录获取token
    func updateUserInfo() -> Promise<String> {
        
        return Promise.init(resolver: { (res) in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                if result {
                    res.fulfill("token - 10086")
                } else {
                    res.reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    // 3、获取用户的数据
    func downloadUserInfo() -> Promise<[String: Any]> {
        
        return Promise.init(resolver: { (res) in
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 2, execute: {
                if result {
                    res.fulfill(["name": "wangwei", "age": 20])
                } else {
                    res.reject(HttpError.networkError)
                }
            })
            print(#function)
        })
    }
    
    // 4、解析用户的数据
    func decoderJSON() -> Promise<UserModel> {
        return Promise(resolver: { (res) in
            if result {
                res.fulfill(UserModel(name: "wangwei", age: 20))
            } else {
                res.reject(HttpError.networkError)
            }
            print(#function)
        })
    }
}

struct Foo : Codable {
    var title: String?
    var userId: Int = 0
    var id: Int = 0
    var body: String?
}

struct UserModel {
    var name: String?
    var age: Int?
}
