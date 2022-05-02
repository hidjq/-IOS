//
//  ProfileModel.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/26.
//

import Foundation

//struct Profile {
//    var username:String
//    var password:String
//
//    static let `default` = Profile(username:"",password:"")
//
//    enum identity:String,CaseIterable {
//        case student = "Student"
//        case professor = "professor"
//    }
//}


struct UserInfo:Codable {
    var username:String
    var password:String
    var identity:String
    var actualName:String
    var grade:String
    
    //static let `default` = UserInfo(username:"",password: "",identity: "",actualName: "",grade:"")
}
