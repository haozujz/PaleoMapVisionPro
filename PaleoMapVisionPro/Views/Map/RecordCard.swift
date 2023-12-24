//
//  RecordCard.swift
//  Paleo
//
//  Created by Joseph Zhu on 12/6/2022.
//

import SwiftUI
import MapKit

struct RecordCard: View {
    @Environment(ModelData.self) private var modelData
    let record: Record
    
    //@Environment(\.verticalSizeClass) var verticalSizeClass
    //@State private var onHover = false
    //@State var snapshot: UIImage?
    
    @State var scene: MKLookAroundScene? = nil
    @State var isSceneShown: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 0) {
                        ForEach(record.media, id: \.self) { image in
                            ImageCell(url: image, cornerRadius: 25.0)
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
//                    onHover = true
//                }
//            })
            
            VStack(spacing: 15.0) {
                Text(
                    (record.commonName.isEmpty
                        ? (record.family.isEmpty ? record.scientificName : record.family)
                        : record.commonName
                    ).capitalized
                )
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
                    .minimumScaleFactor(0.8)
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
                .frame(width: 178)
                .frame(minHeight: 0, maxHeight: 50)
            }
            .frame(width: 246)
        }
        .font(.callout)
        .bold()
        .frame(height: 210)
        .glassBackgroundEffect(in: RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        .task {
            do {
                let result = try await LookAroundService.fetchScene(coord: record.locationCoordinate)
                await MainActor.run {
                    withAnimation(.easeInOut) {
                        scene = result
                    }
                }
            } catch {
                print("\(error)")
            }
        }
        .overlay(alignment: .bottomTrailing) {
            ZStack {
                if scene != nil {
                    LookAroundPreview(initialScene: scene)
                        .opacity(isSceneShown ? 1 : 0)
                        .frame(width: 166, height: 160, alignment: .topLeading)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                        .onTapGesture {
                            isSceneShown = false
                        }
                        .animation(.easeInOut(duration: 0.1), value: isSceneShown)
                }
            }
            .frame(width: 166, height: 160)
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    isSceneShown.toggle()
                }) {
                    Image(systemName: isSceneShown ? "x.circle.fill" : "binoculars.circle.fill")
                        .frame(width: 36, height: 36)
                }
                .offset(y: -36)
                .opacity(scene != nil ? 1 : 0)
                .buttonStyle(PlainButtonStyle())
                .animation(.easeInOut(duration: 0.1), value: scene != nil)
            }
            .overlay(alignment: .bottomTrailing) {
                Button(action: {
                    if modelData.bookmarked.contains(record) {
                        modelData.bookmarked = modelData.bookmarked.filter{ $0.id != record.id }
                    } else {
                        modelData.bookmarked.append(record)
                    }
                }) {
                    Image(systemName: modelData.bookmarked.contains(record) ? "bookmark.circle" : "bookmark.circle.fill")
                        .frame(width: 36, height: 36)
                }
                .buttonStyle(PlainButtonStyle())
                .opacity(isSceneShown ? 0 : 1)
            }
        }
        
    }
}

#Preview(windowStyle: .automatic) {
    RecordCard(record:
                    Record(id: "c605530d-c733-4b90-b092-a1a6bc342e34", commonName: "", scientificName: "cephrenes augiades sperthias (c. felder, 1862)", phylum: .arthropoda, classT: "insecta", order: "lepidoptera", family: "Pieridae Pieridae Pieridae Pieridae Pieridae", locality: "sydney, lugarno, sdfsdfsdfsdfsdfsdfsdfsdfsdfsdf, sdfsd", eventDate: "1981-10-22", media: ["https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012764.JPG", "https://mczbase.mcz.harvard.edu/specimen_images/ent-lepidoptera/images/2009_07_31/IMG_012720.JPG"], geoPoint: GeoPoint(lat: -33.985112, lon: 151.043726))
    )
}


