//
//  Scrap.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//


//                        Annotation(record.family.capitalized, coordinate: record.locationCoordinate) {
//                            MapAnnotationView(color: record.color, icon: record.icon)
//                                .onTapGesture {
//                                    print("tapped")
//                                    selectModel.updateSingleRecord(recordId: record.id, coord: record.locationCoordinate, db: modelData.db, recordsTable: modelData.recordsTable, isLikelyAnnotatedAlready: true)
//                                }
//                        }
//                        .annotationTitles(.hidden)


//        .onChange(of: yaw, initial: false) {
//            guard let lat = viewModel.cameraPosition.region?.center.latitude,
//                  let lon = viewModel.cameraPosition.region?.center.longitude else { return }
//
//            let newLat = pitch * 180.0 / .pi
//            let newLon = yaw * 180.0 / .pi
//
//            let latDiff = abs(newLat - lat)
//            let lonDiff = abs(newLon - lon)
//
//            let threshold = 2.0
//
//            if (latDiff > threshold) && (lonDiff > threshold) {
//                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon))
//            }
//        }
//        .onChange(of: pitch, initial: false) {
//            guard let lat = viewModel.cameraPosition.region?.center.latitude,
//                  let lon = viewModel.cameraPosition.region?.center.longitude else { return }
//
//            let newLat = pitch * 180.0 / .pi
//            let newLon = yaw * 180.0 / .pi
//
//            let latDiff = abs(newLat - lat)
//            let lonDiff = abs(newLon - lon)
//
//            let threshold = 2.0
//
//            if (latDiff > threshold) && (lonDiff > threshold) {
//                viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: newLon))
//            }
//        }


//OLD

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
