//
//  File.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/27.
//

import Foundation
import Combine
import Alamofire

protocol NetworkService {
    func Login(username:String,password:String,completion:@escaping (Result<UserInfo,Error>)->Void)
}


class AccountNetWorkService:NetworkService,ObservableObject {
    func Login(username: String, password: String, completion: @escaping (Result<UserInfo, Error>) -> Void) {
        //http request
        //get user info
        //then
        let userInfo = UserInfo(username: username, password: password,identity: "",actualName: "",grade: "")
        check(userInfo: userInfo,completion:completion)
    }
}


func check(userInfo:UserInfo,completion:@escaping (Result<UserInfo,Error>)->Void){
    let url = "http://localhost:3300/check"
    AF.request(url,method: .post,parameters: ["username":userInfo.username,"password":userInfo.password],encoder:URLEncodedFormParameterEncoder.default)
        .responseData { response in
            switch response.result {
            case .success:
                if let value = response.value {
                    if let returnedUserInfo = try? JSONDecoder().decode(UserInfo.self,from:value){
                        if returnedUserInfo.username != ""{
                            print(returnedUserInfo)
                            completion(.success(returnedUserInfo))
                        }else{
                            let loginError  = NSError(domain: "Login", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot find your account"])
                                completion(.failure(loginError))
                        }
                    }else{
                        let loginError  = NSError(domain: "Login", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot find your account"])
                            completion(.failure(loginError))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
}

func fetchTeacherCourse(name:String,completion:@escaping (Result<Course,Error>)->Void){
    print("<<<<fetch courses>>>>>")
    let url = "http://localhost:3300/teachercourses"
    AF.request(url,
               method: .post,
               parameters: ["name":name],
               encoder:URLEncodedFormParameterEncoder.default)
        .responseData{ response in
            //print(response.data)
            switch response.result {
            case .success:
                if let value = response.value{
                    if let course = try? JSONDecoder().decode(Course.self,from:value){
                        completion(.success(course))
                    }else{
                        let parseError  = NSError(domain: "parse", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot parse courses data"])
                        completion(.failure(parseError))
                    }
                }else{
                    let netError = NSError(domain: "net", code: 0, userInfo: [NSLocalizedDescriptionKey:"have no response value"])
                    completion(.failure(netError))
                }
                break
            case let .failure(error):
                print(error)
                break
            }

    }
}

func fetchTeacherCourseName(username:String,completion:@escaping (Result<Strings,Error>)->Void){
    print("<<<fetch courses names >>>>")
    let url = "http://localhost:3300/courseNames"
    AF.request(url,method:.post,parameters: ["username":username],encoder:URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result{
        case .success:
            if let value = response.value{
                //print(value)
                if let courseNames = try? JSONDecoder().decode(Strings.self,from:value){
                    print(courseNames)
                    completion(.success(courseNames))
                }else{
                    let parseError  = NSError(domain: "parse", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot parse courses data"])
                    completion(.failure(parseError))
                }
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}

func fetchStudentCourseName(username:String,completion:@escaping (Result<Strings,Error>)->Void){
    print("<<<fetch courses names >>>>")
    let url = "http://localhost:3300/courseNamesStudent"
    AF.request(url,method:.post,parameters: ["username":username],encoder:URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result{
        case .success:
            if let value = response.value{
                //print(value)
                if let courseNames = try? JSONDecoder().decode(Strings.self,from:value){
                    print(courseNames)
                    completion(.success(courseNames))
                }else{
                    let parseError  = NSError(domain: "parse", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot parse courses data"])
                    completion(.failure(parseError))
                }
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}

func write(data:Data,to filename:String){
    print("write")
    if let file = Bundle.main.url(forResource:filename,withExtension: nil){
    //if let file = URL(string:"/Users/dengjiaqi/Swift/alamofireTest/alamofireTest/"+filename){
        print(file)
        do{
            do {
                print("?")
                //let jsonData = try JSONEncoder().encode(data)
                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                }
                try data.write(to: file)
            }
            catch {print("wrong")}
        }
    }else{
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    
}


//将isChosen写回数据库
func changeIsChosen(username:String,name:String,isChosen:Int,completion:@escaping(Result<Int,Error>)->Void){
    let url = "http://localhost:3300/isChosen"
    AF.request(url,method: .post,parameters: ["username":username,"name":name,"isChosen":String(isChosen)],encoder:URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result {
        case .success:
            if let value = response.value {
                if let msg = try? JSONDecoder().decode(msg.self,from:value){
                    if(msg.status == 200){
                        completion(.success(200))
                    }else{
                        let chosenError  = NSError(domain: "ischosen", code: 0, userInfo: [NSLocalizedDescriptionKey:"Someting Wrong! You cannot choose \(name)"])
                        completion(.failure(chosenError))
                    }
                }
            }
            break
        case let .failure(error):
            completion(.failure(error))
            print(error)
        }
    }
    
}


func sendCourses(userInfo:UserInfo,course:Course,completion:@escaping (Result<String,Error>)->Void){
    let url = "http://localhost:3300/teacherCourse"
    AF.request(url,method:.post,parameters:["username":userInfo.username,"name":course.name],encoder:URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result {
        case .success:
            if let value = response.value{
                if let msg = try? JSONDecoder().decode(msg.self,from:value){
                    if msg.status==200{
                        completion(.success("Send Course Successfully"))
                    }else{
                        let courseError  = NSError(domain: "course", code: 0, userInfo: [NSLocalizedDescriptionKey:"Cannot send course"])
                        completion(.failure(courseError))
                    }
                }
            }
        case let .failure(error):
            completion(.failure(error))
            print(error)
        }
    }
    
}


func addCourse(userInfo:UserInfo,course:Course,completion:@escaping (Result<String,Error>)->Void){
    let url = "http://localhost:3300/addCourse"
    AF.request(url,method: .post,parameters: ["name":course.name,"Tutor":userInfo.actualName,"date":course.date,"time":course.time,"id":String(course.id),"category":course.category,"imageName":course.imageName,"description":course.description],encoder: URLEncodedFormParameterEncoder.default).responseData{ response in
        switch response.result{
        case .success:
            if let value = response.value{
                if let msg = try? JSONDecoder().decode(msg.self,from:value){
                    if msg.status==200{
                        completion(.success("Add Course Successfully"))
                    }else{
                        let courseError  = NSError(domain: "course", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot add course"])
                        completion(.failure(courseError))
                    }
                }
            }
        case let .failure(error):
            completion(.failure(error))
            print(error)
        }
        
    }
}

func fetchCourses(username:String,names:Strings,completion:@escaping (Result<Courses,Error>)->Void){
    let namesString = names.joined(separator: ",")
    let url = "http://localhost:3300/studentCourses"
    AF.request(url,method: .post,parameters: ["username":username,"names":namesString],encoder: URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result {
        case .success:
            if let value = response.value {
                if let courses = try? JSONDecoder().decode(Courses.self,from:value){
                    completion(.success(courses))
                }else{
                    let parseError = NSError(domain: "parse", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot parse courses"])
                    completion(.failure(parseError))
                }
            }
        case let .failure(error):
            completion(.failure(error))
            print(error)
        }
    }
}

func loadCourses(username:String,completion:@escaping (Result<Courses,Error>)->Void){
    fetchStudentCourseName(username: username) { result in
        switch result{
        case let .success(names):
            fetchCourses(username: username, names: names) { result in
                switch result {
                case let.success(datacourses):
                    completion(.success(datacourses))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        case let .failure(error):
            print(error)
        }
    }
}


func showStudent(name:String,completion:@escaping (Result<Strings,Error>)->Void){
    let url = "http://localhost:3300/showStudent"
    AF.request(url,method: .post,parameters: ["name":name],encoder:URLEncodedFormParameterEncoder.default).responseData { response in
        switch response.result {
        case .success:
            if let value = response.value{
                if let studentNos = try? JSONDecoder().decode(Strings.self,from:value){
                    completion(.success(studentNos))
                }
            }else {
                let studentError = NSError(domain: "students", code: 1, userInfo: [NSLocalizedDescriptionKey:"Cannot show students"])
                completion(.failure(studentError))
            }
            break;
        case let .failure(error):
            completion(.failure(error))
            print(error)
        }
    }
}

func findName(username:String,completion:@escaping(Result<UserInfo,Error>)->Void){
    let url = "http://localhost:3300/findName"
    AF.request(url,method: .post,parameters: ["username":username],encoder: URLEncodedFormParameterEncoder.default).responseData{response in
        switch response.result{
        case .success:
            if let value = response.value {
                if let info = try? JSONDecoder().decode(UserInfo.self,from:value){
                    completion(.success(info))
                }
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
