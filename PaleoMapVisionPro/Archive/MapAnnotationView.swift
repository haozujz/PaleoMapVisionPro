//
//  MapAnnotationView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//

import SwiftUI

struct MapAnnotationView: View {
    let color: Color
    let icon: String
    
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundColor(color)
                .saturation(0.6)
                .font(.system(size: 35))
            Image(systemName: icon)
                .foregroundColor(Color.init(red:0.1, green:0.1, blue:0.1))
                .scaleEffect(CGSize(width: icon == "hare.fill" || icon == "fossil.shell.fill" || icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                .scaleEffect(icon == "seal.fill" ? 0.8 : 1.0)
                .rotationEffect(.degrees(icon == "hurricane" ? -20.0 : 0.0))
                .font(.system(size: icon == "hare.fill" || icon == "ant.fill" ? 20 : 25, weight: icon == "seal.fill" ? .thin : .bold))
                .offset(y: icon == "hare.fill" || icon == "ant.fill" ? -1 : 0)
        }
        .symbolRenderingMode(.monochrome)
    }
}

//#Preview {
//    MapAnnotationView()
//}
