//
//  EditAlarmView.swift
//  test_app
//
//  Created by ayana taba on 2024/06/02.
//

import SwiftUI

struct EditAlarmView: View {
    @Binding var wakeUpTime: Date
    @Binding var bedTime: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("起床時間")) {
                    DatePicker("起床時間", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("就寝時間")) {
                    DatePicker("就寝時間", selection: $bedTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationBarTitle("アラーム編集", displayMode: .inline)
            .navigationBarItems(trailing: Button("完了") {
                presentationMode.wrappedValue.dismiss()
            })
            //常時背景色を適用
            .toolbarBackground(.visible, for: .navigationBar)
            //背景色をグリーンにする
            .toolbarBackground(.green.opacity(0.3),for: .navigationBar)
        }
    }
}

struct EditAlarmView_Previews: PreviewProvider {
    static var previews: some View {
        EditAlarmView(wakeUpTime: .constant(Date()), bedTime: .constant(Date()))
    }
}
