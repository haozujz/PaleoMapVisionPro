//
//  PhylumToggle.swift
//  Paleo
//
//  Created by Joseph Zhu on 16/7/2022.
//

import SwiftUI

struct PhylumToggle: View {
    @Binding var isActive: Bool
    let phylum: Phylum
    private let icon: String
    private let colors: [Color]
    
    init(isActive: Binding<Bool>, phylum: Phylum) {
        self._isActive = isActive
        self.phylum = phylum
        self.icon = phylum.icon
        self.colors = phylum.colors
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .frame(width: 160, height: 80)
                .multicolorGlow(colors: colors, isActive: isActive)
                .opacity(colors == [.brown] || colors.count > 1 ? 1.0 : 0.8)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(.white)
                .opacity(isActive ? 0.2 : 0.5)
                .frame(width: 160, height: 80)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(AngularGradient(gradient: Gradient(colors: colors), center: .center))
                .opacity(isActive ? 0.5 : 0.1)
                .frame(width: 160, height: 80)
                .shadow(color: Color(red:0.1, green:0.1, blue:0.1).opacity(0.8), radius: 1, x: 0, y: 1)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: 160, height: 80)

            Image(systemName: icon)
                .foregroundStyle(.regularMaterial)
                .font(.system(size: 80, weight: .bold))
                .scaleEffect(CGSize(width: icon == "hare.fill" || icon == "fossil.shell.fill" || icon == "bird.fill" ? -1.0 : 1.0, height: 1.0))
                .rotationEffect(.degrees(icon == "hurricane" ? -20.0 : 0.0))
                .offset(y: 18)
                .symbolRenderingMode(.monochrome)
                .frame(width: 160, height: 80)
                .cornerRadius(25)
            
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(isActive ? Color(red:0.05, green:0.05, blue:0.05) : Color(red:0.05, green:0.05, blue:0.05))
                .opacity(isActive ? 0.7 : 0.9)
                .frame(width: 58, height: 30)
                .offset(x: 43, y: 18)
                .allowsHitTesting(false)
            
            Circle()
                .foregroundStyle(.ultraThinMaterial)
                .frame(width: 22, height: 22)
                .shadow(color: Color(red:0.05, green:0.05, blue:0.05), radius: 2, x: 0, y: 1)
                .offset(x: isActive ? 57 : 32, y: 18)
                .allowsHitTesting(false)
            
            Text(phylum.rawValue.capitalized)
                .frame(width: 150, height: 40, alignment: .leading)
                //.font(.system(size: 22, weight: .heavy))
                .font(.title2)
                .scaledToFit()
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                .offset(x: 0, y: -20)
                .allowsHitTesting(false)
        }
        .animation(.spring(response: 0.05), value: isActive)
        .frame(width: 160, height: 80)
        .onTapGesture {
            isActive = !isActive
        }
    }
}

extension View {
    func multicolorGlow(colors: [Color], isActive: Bool) -> some View {
        ZStack {
            ForEach(0..<2) { i in
                Rectangle()
                    .fill(AngularGradient(gradient: Gradient(colors: colors), center: .center))
                    .mask(self.blur(radius: 20))
                    .opacity(isActive ? 0.7 : 0.0)
            }
            Rectangle()
                .fill(.white)
                .mask(self.blur(radius: 20))
                .opacity(isActive ? 0.3 : 0.1)
        }
        .frame(width: 300, height: 200)
        .scaleEffect(0.8)
        .offset(y: 8)
    }
}

struct PhylumToggle_Previews: PreviewProvider {
    static var previews: some View {
        PhylumToggle(isActive: .constant(true), phylum: Phylum.chordata)
            .background(Color(red:0.05, green:0.05, blue:0.05))
            .preferredColorScheme(.dark)
    }
}
