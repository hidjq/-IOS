//
//  UserRepository.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/27.
//

import Foundation
protocol UserRepositoryProtocol {
    func Login(username: String, password: String, completion: @escaping (Result<UserInfo, Error>) -> Void)
}

final class UserRepository:UserRepositoryProtocol {
    
    private let netService:NetworkService
    init(service:NetworkService = AccountNetWorkService()){
        self.netService = service
    }
    
    func Login(username:String,password:String,completion:@escaping(Result<UserInfo,Error>)->Void){
        //调用数据服务获取数据
        netService.Login(username: username, password: password, completion: completion)
    }
}
