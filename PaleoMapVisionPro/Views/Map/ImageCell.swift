//
//  RecImage.swift
//  Paleo
//
//  Created by Joseph Zhu on 27/7/2022.
//

import SwiftUI

struct ImageCell: View {
    //@EnvironmentObject private var selectModel: RecordSelectModel
    //@EnvironmentObject private var imageModel: ImageModel
    let url: String
    
    // Allow reconnecting to media URL (require change 'url' ref in body to 'urlToLoad'
//    @State private var urlToLoad: String
    
//    init(url: String) {
//        self.url = url
//        self._urlToLoad = State(initialValue: url)
//    }
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.black)

                        ProgressView()
                    }
                case .success(let image):
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.black)

                        image.resizable().scaledToFit()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
//                    .onTapGesture {
//                        imageModel.image = image
//                        imageModel.isShowImage = true
//                    }
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.black)

                        Text("|  Image not available   |")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                    }
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 25, style: .continuous)
//                            .fill(.black)
//
//                        Link("| Tap here to view in browser |", destination: URL(string: url)!)
//                                                        .font(.system(size: 16, weight: .bold))
//                                                        .foregroundColor(.white)
//                    }
                    
//                            Text(selectModel.isDetailedMode ? "|  Tap here to refresh  |" : "")
//                                .font(.system(size: 16, weight: .bold))
//                                .foregroundColor(.gray)
//                                .onTapGesture {
//                                    let x = url
//
//                                    DispatchQueue.main .asyncAfter(deadline: .now() + 0.1){
//                                        urlToLoad = x
//                                    }
//                                    urlToLoad = ""
//                                }
                default:
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.black)

                        Text("|  Image not available   |")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                
            }
//        .task {
//            print(">>>\(url)")
//        }
        }
}

//bug: TabView w/ PageTabViewStyle gives memory leaks if selection: $currentIndex is passed
//
//struct ExtractedView: View {
//    var body: some View {
//        ForEach(media.indices, id: \.self){ i in
//            ZStack {
//                RoundedRectangle(cornerRadius: 25, style: .continuous)
//                    .fill(.black)
//
//                AsyncImage(url: URL(string: media[0])) { phase in
//                    switch phase {
//                    case .empty:
//                        ProgressView()
//                    case .success(let image):
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 25, style: .continuous)
//                                .fill(.black)
//
//                            image.resizable().scaledToFit()
//                        }
//                    case .failure:
//                        Text("")
//                    default:
//                        Text("")
//                    }
//                }
//            }
//            .tag(i as Int)
//        }
//    }
//}
