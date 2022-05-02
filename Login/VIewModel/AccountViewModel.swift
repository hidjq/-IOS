//
//  AccountViewModel.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/20.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

final class AccountViewModel:ObservableObject{
    @AppStorage("isLogin") var isLogin:Bool = false
    //courses根据userInfo从数据库中获取
    @Published var courses:[Course] = []
    //load("CourseData.json")
    //loadCourses(with: loadUserInfo().username)
    
    @Published var teacherCourses:[Course] = []

    var chosens:[Course]{
        courses.filter{$0.isChosen==1}
        //选择或删除课程，传入数据库
    }
    var categories:[String:[Course]]{
        Dictionary(
            grouping:courses,
            by:{$0.category}
        )
    }
  
    @Published var userInfo:UserInfo = loadUserInfo(){
        didSet{
            print("didSet")
            save(userInfo: userInfo)
        }
    }
    
    
    private let repository:UserRepositoryProtocol
    
    //viewModel 初始化
    init(repository:UserRepositoryProtocol = UserRepository()){
        self.repository = repository
    }
    
}

//[Course(name:"Math",Tutor:"Wang",isChosen:true,id:1,date:"week1-week11",time:"8:00-9:45",category: .freshman,imageName:"Math",description: "Beginner friendly")]

extension AccountViewModel {
    func Login(username:String,password:String,completion:@escaping (Result<UserInfo,Error>)->Void){
        repository.Login(username: username, password: password) { result in
            switch result {
            case .success(let data):
                self.userInfo = data
                completion(.success(self.userInfo))
            case .failure(let error):
                //self.isLogin = false
                self.userInfo = UserInfo(username: "", password: "", identity: "", actualName: "", grade: "")
                completion(.failure(error))
                print(error.localizedDescription)
            }
        }
    }
}


func load<T:Decodable>(_ filename:String)->T {
    let data:Data
    
    guard let file = Bundle.main.url(forResource:filename,withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf :file)
    }catch{
        fatalError("Couldn't parse \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func save(userInfo:UserInfo){
    UserDefaults.standard.set(userInfo.username, forKey: "username")
    UserDefaults.standard.set(userInfo.password,forKey: "password")
    UserDefaults.standard.set(userInfo.identity,forKey: "identity")
    UserDefaults.standard.set(userInfo.actualName,forKey:"actualName")
}
func loadUserInfo()->UserInfo{
    let username = UserDefaults.standard.string(forKey: "username")
    let password = UserDefaults.standard.string(forKey: "password")
    let identity = UserDefaults.standard.string(forKey: "identity")
    let actualName = UserDefaults.standard.string(forKey: "actualName")
    var userInfo = UserInfo(username: "", password: "", identity: "", actualName: "", grade: "")
    if let username = username {
        if let password = password {
            if let identity = identity {
                if let actualName = actualName{
                    userInfo.username = username
                    userInfo.password = password
                    userInfo.identity = identity
                    userInfo.actualName = actualName
                }
            }
        }
    }
    return userInfo
}

func loadTeacherCourses(with username:String,completion:@escaping (Result<Courses,Error>)->Void){
    print("<<<<<<<<<load courses>>>>>>>>>")
    var courseNames:[String] = []
    var teacherCourses:Courses = []
    fetchTeacherCourseName(username: username) { result in
        switch result {
        case let .success(dataCourseNames):
            courseNames = dataCourseNames
            print(courseNames)
            for name in courseNames{
                fetchTeacherCourse(name: name) { result in
                    switch result {
                    case let .success(dataCourses):
                        teacherCourses.append(dataCourses)
                        completion(.success(teacherCourses))
                        print("expanded:\(teacherCourses)")
                    case let .failure(error):
                        print(error)
                        completion(.failure(error))
                    }
                }
            }
        case let .failure(error):
            print(error)
            break
        }
    }
}
