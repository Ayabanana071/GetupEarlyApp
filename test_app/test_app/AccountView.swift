import SwiftUI

struct AccountView: View {
    @State private var username: String = "ユーザー名"
    @State private var email: String = "user@example.com"
    @State private var notificationsEnabled: Bool = true

    var body: some View {
        Form {
            Section(header: Text("アカウント情報")) {
                HStack {
                    Text("ユーザー名")
                    Spacer()
                    Text(username)
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("メール")
                    Spacer()
                    Text(email)
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("設定")) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("通知を有効にする")
                }
            }
            
            Section {
                Button(action: {
                    // ログアウト処理をここに追加
                }) {
                    Text("ログアウト")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("アカウント")
    }
}

#Preview {
    AccountView()
}
