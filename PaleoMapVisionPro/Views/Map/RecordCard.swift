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
    
    @State private var slideWidth: CGFloat = 0
        
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 10.0) {
                Text("\(record.scientificName)".capitalized)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(.primary)
                    .frame(width: 300)
                
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
                }
                .font(.callout)
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 200)
                
                
                VStack {
                    Text("\(record.eventDate)")
                    Text("\(record.locality)".capitalized)
                }
                .font(.callout)
                .bold()
                .foregroundStyle(.secondary)
                .frame(width: 200)
            }
            .offset(x: 20)
            .frame(width: 300, height: 200) // Adjust width based on slideWidth
            .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            .offset(x: slideWidth)
            
            ImageCell(url: record.media.first!)
                .id(record.media.first!)
                .frame(width: 300, height: 200)
        }
        .onTapGesture {
            if slideWidth == 0 {
                withAnimation {
                    slideWidth = 256
                }
            } else {
                withAnimation {
                    slideWidth = 0
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    RecordCard(record:
                    Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae", locality: "sydney, lugarno", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: GeoPoint(lat: -33.985112, lon: 151.043726))
    )
}


