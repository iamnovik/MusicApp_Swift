import SwiftUI
import FirebaseAuth
struct Home: View {
    @EnvironmentObject var authenticationService: AuthenticationService
    //@StateObject var databaseService = DatabaseService(uid: ) // Замените "your_uid_here" на фактический uid
    
    var body: some View {
        NavigationView {
            VStack {
                // AppBar
           
                
                // AlbumList
                AlbumList(onlyFavourites: false)
                
                Spacer()
            }
            .navigationBarTitle("Albums", displayMode: .inline) // Пустой заголовок, скрытие стандартного заголовка
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                        trailing:
                            HStack {
                                NavigationLink(destination: SettingsView()) {
                                    Image(systemName: "person.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                                NavigationLink(destination: Favourites()) {
                                    Image(systemName: "heart")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                                NavigationLink(destination: Wrapper()) {
                                    Image(systemName: "list.bullet")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                            }
                    )
            //.background(Color.backgroundColor.edgesIgnoringSafeArea(.all)) // Цвет фона
        }
        .navigationBarHidden(true) // Скрытие стандартной строки навигации
    }
    
}
