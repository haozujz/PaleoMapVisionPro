//
//  RecordCard2.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//

import SwiftUI
import MapKit

struct RecordCard2: View {
    let record: Record
    
    //@State private var slideWidth: CGFloat = 0
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
        
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 10.0) {
                Text("\(record.scientificName)".capitalized)
                    .lineLimit(1)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(.primary)
                    .frame(width: 246)
                
                HStack {
                    VStack {
                        Text("Phylum")
                        Text("Class")
                        Text("Order")
                        Text("Family")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("\(record.phylum)".capitalized)
                        Text("\(record.classT)".capitalized)
                        Text("\(record.order)".capitalized)
                        Text("\(record.family)".capitalized)
                    }
                    .lineLimit(1)
                }
                .font(.callout)
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 200)
                
                VStack {
                    Text("\(record.eventDate)")
                    Text("\(record.locality)".capitalized)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }
                .font(.callout)
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 246)
                .frame(minHeight: 0, maxHeight: 50)
            }
            .offset(x: 20)
            .frame(width: 295, height: 200)
//            .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            //.offset(x: slideWidth)
            .offset(x: 256.0)
            
//            ImageCell(url: record.media.first!)
//                .id(record.media.first!)
//                .frame(width: 300, height: 200)
            
            ZStack {
//                TabView() {
//                    ForEach(0..<record.media.count, id: \.self) { i in
//                        ImageCell(url: record.media[i])
//                    }
//                }
//                .tabViewStyle(.page)
//                //.indexViewStyle(.page(backgroundDisplayMode: .always))
//                .frame(width: 300, height: 200)
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0) {
                        ForEach(record.media, id: \.self) { image in
                            ImageCell(url: image)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        }
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicatorsFlash(onAppear: true)
                .scrollIndicators(.visible)
                .frame(width: 300, height: 200)
            }
            .id(record.id)
        }
        
//        .onTapGesture {
//            if slideWidth == 0 {
//                withAnimation {
//                    slideWidth = 256
//                }
//            } else {
//                withAnimation {
//                    slideWidth = 0
//                }
//            }
//        }
    }
}

#Preview(windowStyle: .automatic) {
    RecordCard2(record:
                    Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "sydney, lugarno, sdfsdfsdfsdfsdfsdfsdfsdfsdfsdf, sdfsd", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: GeoPoint(lat: -33.985112, lon: 151.043726))
    )
}



