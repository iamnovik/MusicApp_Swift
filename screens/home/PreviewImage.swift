import SwiftUI
import FirebaseStorage

struct PreviewImage: View {
    let path: String
    @State private var image: UIImage? = nil

    func getFileUrl(firebasePath: String, completion: @escaping (URL?) -> Void) {
        let storageRef = Storage.storage().reference().child(firebasePath)
        storageRef.downloadURL { (url, error) in
            if let error = error {
                print("Failed with error: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(url)
            }
        }
    }

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .frame(height:120)
                .aspectRatio(contentMode: .fit)
        } else {
            Image(systemName: "heart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
                .onAppear {
                    getFileUrl(firebasePath: path) { url in
                        if let url = url {
                            URLSession.shared.dataTask(with: url) { data, _, error in
                                if let data = data {
                                    DispatchQueue.main.async {
                                        self.image = UIImage(data: data)
                                    }
                                }
                            }.resume()
                        }
                    }
                }
        }
    }
}
