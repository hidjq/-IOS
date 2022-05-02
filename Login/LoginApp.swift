//
//  LoginApp.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/19.
//

import SwiftUI
import Foundation

@main
struct LoginApp: App {
    @StateObject var AccountVM=AccountViewModel()
    var body: some Scene {
        WindowGroup {
            if AccountVM.isLogin == true {
                ContentView().environmentObject(AccountVM)
            }else {
                LoginView().environmentObject(AccountVM)
            }
        }
    }
}
