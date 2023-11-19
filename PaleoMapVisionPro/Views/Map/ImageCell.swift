//
//  RecImage.swift
//  Paleo
//
//  Created by Joseph Zhu on 27/7/2022.
//

import SwiftUI

struct ImageCell: View {
    let url: String
    let cornerRadius: Double
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.black)

                        ProgressView()
                    }
                case .success(let image):
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.black)

                        image.resizable().scaledToFit()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.black)

                        Link("| Tap here to view in browser |", destination: URL(string: url)!)
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(.white)
                    }
                default:
                    ZStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.black)

                        Text("|  Image not available   |")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }
                
            }
        }
}
