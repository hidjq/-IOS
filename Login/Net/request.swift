//
//  request.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/12/4.
//

import Foundation


func get(urlString:String){
    let url = URL(string: urlString)!
    let request  = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error{
            //在UI上显示错误
            return
        }
        guard let response = response as? HTTPURLResponse, response.statusCode >= 200,response.statusCode<=300 else {
            //响应无效
            return
        }
        guard let data = data else {
            return
        }
    }
    task.resume()
}

