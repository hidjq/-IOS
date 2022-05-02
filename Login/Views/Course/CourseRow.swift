//
//  CourseRow.swift
//  Login
//
//  Created by 干饭人肝不完DDL on 2021/11/25.
//

import SwiftUI

struct CourseRow: View {
    @EnvironmentObject var AccountVm:AccountViewModel
    var course:Course
    var courseIndex:Int {
        AccountVm.courses.firstIndex(where:{$0.id == course.id})!
    }
    var body: some View {
        HStack{
            course.image
                .resizable()
                .frame(width:50,height:50)
                .clipShape(RoundedRectangle(cornerRadius: 30))
            Text(course.name)
            Spacer()
            if AccountVm.userInfo.identity == "student"{
                ChooseButton(course:AccountVm.courses[courseIndex],isSet: $AccountVm.courses[courseIndex].isChosen)
            }
        }
        .background(Color.black.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(5)
    }
}

struct CourseRow_Previews: PreviewProvider {
    static let AccountVM = AccountViewModel()
    static var previews: some View {
        CourseRow(course:Course(name: "History", Tutor: "Wang", isChosen: 1, id: "12", date: "Week1", time: "12:00-14:00", category: "Freshman", imageName: "PE", description: "None"))
            .environmentObject(AccountVM)
    }
}
