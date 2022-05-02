//
//  StudentInfoList.swift
//  Hitters
//
//  Created by 干饭人肝不完DDL on 2021/12/25.
//

import SwiftUI
struct StudentInfoList: View {
    var course:Course
    @State var isShow:Bool = false
    @State var studentNos:Strings = []
    @State var actualNames:Strings = []
    @State var grades:Strings = []
    var body: some View {
        VStack{
            HStack{
                Button{
                    isShow.toggle()
                    if(isShow){
                        showStudent(name: course.name) { result in
                            switch result{
                            case let .success(dataStudentNos):
                                studentNos = dataStudentNos
                                print(studentNos)
                                for studentNo in studentNos {
                                    findName(username: studentNo) { result in
                                        switch result{
                                        case let .success(info):
                                            actualNames.append(info.actualName)
                                            grades.append(info.grade)
                                        case let .failure(error):
                                            print(error)
                                        }
                                    }
                                }
                            case let.failure(error):
                                print(error)
                            }
                        }
                    }else{
                        actualNames = []
                        grades = []
                    }
                }label:{
                    HStack{
                        Text("Show Students")
                            .bold()
                            .foregroundColor(.green)
                        Label("Graph", systemImage:"chevron.right.circle")
                            .labelStyle(.iconOnly)
                            .imageScale(.large)
                            .rotationEffect(.degrees(isShow ? 90 : 0))
                            .padding()
                            .animation(.easeInOut, value: isShow)
                    }
                }
                .padding(5)
                Spacer()
            }
            .padding(5)
            .frame(maxHeight: .infinity, alignment: .leading)
            HStack{
                VStack{
                    if(isShow){
                        Text("studentNo").foregroundColor(.blue)
                    }
                    ForEach(studentNos,id:\.self){ studentNo in
                        if(isShow){
                            VStack{
                                Text(studentNo)
                            }
                            .padding(5)
                            .frame(width: 120)
                        }else{
                            Text("")
                        }
                    }
                }
                VStack{
                    if(isShow){
                        Text("name").foregroundColor(.blue)
                    }
                    ForEach(actualNames,id:\.self){ actualName in
                        if(isShow){
                            VStack{
                                Text(actualName)
                            }
                            .frame(width: 120)
                            .padding(5)
                        }else{
                            Text("")
                        }
                    }
                }
                VStack{
                    if(isShow){
                        Text("grade").foregroundColor(.blue)
                    }
                    ForEach(grades,id:\.self){grade in
                        if(isShow){
                            VStack{
                                Text(grade)
                            }
                            .padding(5)
                            .frame(width: 120)
                        }else{
                            Text("")
                        }
                    }
                }
            }
        }
    }
}

struct StudentInfoList_Previews: PreviewProvider {
    static var previews: some View {
        StudentInfoList(course: Course.default)
    }
}
