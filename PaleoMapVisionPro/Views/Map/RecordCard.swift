//
//  RecordCard.swift
//  Paleo
//
//  Created by Joseph Zhu on 12/6/2022.
//

import SwiftUI
import MapKit

struct RecordCard: View {
    let record: Record
    
    //@Environment(\.verticalSizeClass) var verticalSizeClass
    @State private var overImage = false
        
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0) {
                        ForEach(record.media, id: \.self) { image in
                            ImageCell(url: image)
                                .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        }
                    }
                }
                .contentMargins(8, for: .scrollIndicators)
                .scrollTargetBehavior(.paging)
                .scrollIndicatorsFlash(onAppear: true)
                //.scrollIndicatorsFlash(trigger: true)
                .frame(width: 300)
            }
            .id(record.id)
//            .onHover(perform: { hovering in
//                print("hovering")
//                print("\(hovering)")
//                
//                if hovering {
//                    overImage = true
//                }
//            })
            
            VStack(spacing: 15.0) {
                Text("\(record.scientificName)".capitalized)
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                    .frame(width: 240)
                
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
                .foregroundStyle(.secondary)
                .frame(width: 200)
                
                VStack {
                    Text("\(record.eventDate)")
                    Text("\(record.locality)".capitalized)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }
                .foregroundStyle(.secondary)
                .frame(width: 240)
                .frame(minHeight: 0, maxHeight: 50)
            }
            .frame(width: 246)
        }
        .font(.callout)
        .bold()
        .frame(height: 210)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 25.0, style: .continuous))
    }
}

#Preview(windowStyle: .automatic) {
    RecordCard(record:
                    Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "sydney, lugarno, sdfsdfsdfsdfsdfsdfsdfsdfsdfsdf, sdfsd", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: GeoPoint(lat: -33.985112, lon: 151.043726))
    )
}


