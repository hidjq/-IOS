//
//  AccountModel.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/19.
//

import Foundation
import SwiftUI

//TextField 类型
enum TextFieldType {
    case text
    case password
}

struct Course :Hashable,Identifiable,Codable{
    
    var name:String
    var Tutor:String
    var isChosen:Int
    var id:String
    var date:String
    var time:String
    var category:String
    
//    enum Category:String,Codable,CaseIterable {
//        case freshman = "Freshman"
//        case sophomore = "Sophomore"
//        case junior = "Junior"
//        case senior = "Senior"
//    }
    
    var imageName:String
    var image: Image {
        Image(imageName)
    }
    var description:String
    
    static let `default` = Course(name: "", Tutor: "", isChosen: 0, id:"", date: "", time: "", category: "", imageName: "", description: "")
}
enum Tab {
    case CourseList
    case Categories
}
struct msg:Codable {
    var msg:String
    var status:Int
}
typealias Courses = [Course]
typealias Strings = [String]
