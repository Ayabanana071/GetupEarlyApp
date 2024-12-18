import SwiftUI

struct AccountView: View {
    @StateObject private var missionViewModel = MissionViewModel()
    @StateObject private var earlyRiseViewModel = EarlyRiseViewModel()
    @Binding var isLogin: Bool
    
    @State private var username: String = "Loading..."
    @State private var createdAt: String = "Loading..."
    @State private var errorMessage: String = ""

    var body: some View {
        ScrollView{
            VStack {
                if !errorMessage.isEmpty {
                    GroupBox{
                        GroupBox{
                            HStack{
                                Spacer()
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            Text(" ログインし直してください")
                                .foregroundColor(.red)
                        }
                        .backgroundStyle(.white)
                    }
                    .padding()
                    .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                    
                         
                } else {
                    GroupBox{
                        Text("アカウント情報")
                            .foregroundColor(Color(red: 48/255, green: 178/255, blue: 127/255))
                            .fontWeight(.medium)
                            .font(.title3)
                        GroupBox{
                            HStack{
                                Text("ユーザー名")
                                Spacer()
                                Text(username)
                                    .foregroundColor(.gray)
                            }
                        }
                        .backgroundStyle(.white)
                        
                        GroupBox{
                            HStack{
                                Text("登録日")
                                Spacer()
                                Text(createdAt)
                                    .foregroundColor(.gray)
                            }
                        }
                        .backgroundStyle(.white)
                    }
                    .padding([.leading, .bottom, .trailing])
                    .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                }
                
                RecordView()
                
                GroupBox {
                    HStack{
                        Text("早起き達成日数")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.medium)
                            .font(.headline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("\(earlyRiseViewModel.totalSuccessCount)日")
                            .font(.largeTitle)
                            .foregroundColor(Color.accentColor)
                            .padding()
                    }
                }
                .compositingGroup()
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .padding()
                
                GroupBox {
                    HStack{
                        Text("ミッション達成数")
                            .foregroundColor(Color("MainColor"))
                            .fontWeight(.medium)
                            .font(.headline)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text("\(missionViewModel.totalClearMissionsCount)回")
                            .font(.largeTitle)
                            .foregroundColor(Color.accentColor)
                            .padding()
                    }
                }
                .compositingGroup()
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))
                .padding()
                
                GroupBox{
                    GroupBox{
                        HStack{
                            Spacer()
                            Button("ログアウトする") {
                                logout()
                            }
                            .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .backgroundStyle(.white)
                }
                .padding([.leading, .bottom, .trailing])
                .backgroundStyle(Color(red: 238/255, green: 240/255, blue: 237/255))

                
            }
            .padding()
            .onAppear {
                fetchUserData()
                missionViewModel.fetchTotalClearMissionsCount()
                earlyRiseViewModel.fetchTotalSuccessCount()
            }
        }
    }

    func fetchUserData() {
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let url = URL(string: "http://localhost:3000/me") else {
            errorMessage = "トークンが見つかりませんでした。"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            username = json["name"] as? String ?? "Unknown"
                            createdAt = json["created_at"] as? String ?? "Unknown"
                        }
                    } catch {
                        errorMessage = "データ解析に失敗しました"
                    }
                } else {
                    errorMessage = "ユーザーデータの取得に失敗しました"
                }
            }
        }.resume()
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "userToken")
        isLogin = false
    }
}

#Preview {
    @State var isLoginPreview = true
    return AccountView(isLogin: $isLoginPreview)
}
