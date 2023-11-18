//
//  Scrap.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 12/11/2023.
//



//ScrollTransition
//                                .scrollTransition { content, phase in
//                                    content
//                                        .opacity(phase.isIdentity ? 1.0 : 0.8)
//                                }
//                                .background(
//                                    RoundedRectangle(cornerRadius: 25, style: .continuous)
//                                        .fill(.black)
//                                )

//ItemView Method for globe 3dmodel
//            ItemView(item: .)
//                .opacity(isGlobeShown ? 1 : 0)
            
//            Model3D(named: "Scene", bundle: realityKitContentBundle)
//                .dragRotation(
//                    yaw: $yaw,
//                    pitch: $pitch)
//                //.offset(z: 240.0)
//                //.offset(x: -140, y: 0)
//                //.rotation3DEffect(.degrees(12), axis: (x: 1.0, y: 1.0, z: 0.0))
////                .rotation3DEffect(.degrees((yaw * 180.0 / .pi) + 67.5), axis: (x: 0.0, y: 1.0, z: 0.0)) // Apply yaw
////                .rotation3DEffect(.degrees(pitch * 180.0 / .pi), axis: (x: 1.0, y: 0.0, z: 0.0)) // Apply pitch
//                .opacity(isGlobeShown ? 1 : 0)
//                .offset(z: 120.0)
//                .offset(x: -20.0)




//private enum Item: String, CaseIterable, Identifiable {
//    case globe
//    var id: Self { self }
//    var name: String { rawValue.capitalized }
//}


// CustomBinding
//                GlobeView(
//                    longitude: Binding(
//                        get: { viewModel.cameraPosition.region?.center.longitude ?? 0.0 },
//                        set: { newLon in
//                            print(newLon)
//                            //self.viewModel.updateLongitude(newLongitude: newLongitude)
//                            viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: viewModel.cameraPosition.region?.center.latitude ?? 0.0, longitude: newLon))
//                        }
//                    ),
//                    latitude: Binding(
//                        get: { viewModel.cameraPosition.region?.center.latitude ?? 0.0 },
//                        set: { newLat in
//                            //self.viewModel.updateLatitude(newLatitude: newLatitude)
//                            viewModel.changeLocation(coord: CLLocationCoordinate2D(latitude: newLat, longitude: viewModel.cameraPosition.region?.center.longitude ?? 0.0))
//                        }
//                    )
//                )



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


//OLD IMAGE

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


// Allow reconnecting to media URL (require change 'url' ref in body to 'urlToLoad'
//    @State private var urlToLoad: String

//    init(url: String) {
//        self.url = url
//        self._urlToLoad = State(initialValue: url)
//    }

//@EnvironmentObject private var selectModel: RecordSelectModel
//@EnvironmentObject private var imageModel: ImageModel

//                    .onTapGesture {
//                        imageModel.image = image
//                        imageModel.isShowImage = true
//                    }



// Equatable MKCoordinateSpan
//extension MKCoordinateSpan: Equatable {}
//
//public func ==(lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
//    return lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
//}
//
//extension MKCoordinateRegion: Equatable {}
//
//public func ==(lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
//    return lhs.center == rhs.center && lhs.span == rhs.span
//}

//OLD Phylum toggle

//var icon: String {
//    switch phylum {
//    case .annelida: return "hurricane"
//    case .archaeocyatha: return "aqi.medium"
//    case .arthropoda: return "ant.fill"
//        
//    case .brachiopoda:
//        if #available(iOS 16.0, *) {return "fossil.shell.fill"}
//        else {return "seal.fill"}
//    case .bryozoa: return "aqi.medium"
//    case .chordata: return "hare.fill"
//        
//    case .cnidaria: return "snowflake"
//    case .coelenterata: return "aqi.medium"
//    case .echinodermata: return "staroflife.fill"
//        
//    case .mollusca:
//        if #available(iOS 16.0, *) {return "fossil.shell.fill"}
//        else {return "seal.fill"}
//    case .platyhelminthes: return "hurricane"
//    case .porifera: return "aqi.medium"
//    }
//}
//
//var colors: [Color] {
//    switch self.phylum {
//    case .annelida: return [.brown]
//    case .archaeocyatha: return [.blue]
//    case .arthropoda: return [.purple]
//        
//    case .brachiopoda: return [.orange]
//    case .bryozoa: return [.blue]
//    case .chordata: return [.yellow, .cyan, .cyan, .green, .green, .indigo, .indigo, .yellow]
//        
//    case .cnidaria: return [.pink]
//    case .coelenterata: return [.blue]
//    case .echinodermata: return [.red]
//        
//    case .mollusca: return [.orange]
//    case .platyhelminthes: return [.brown]
//    case .porifera: return [.blue]
//    }
//}

//OLD FilterView
//@State private var filterDict: [Phylum : Bool]

//    init() {
//        var x: [Phylum : Bool] = [:]
//        var dict = UserDefaults.standard.dictionary(forKey: "filterDict") as? [String : Bool] ?? [:]
//
//        if dict == [:] {
//            var y: [String : Bool] = [:]
//            Phylum.allCases.forEach { phylum in
//                y[phylum.rawValue] = true
//            }
//            UserDefaults.standard.set(y, forKey: "filterDict")
//            dict = y
//        }
//        for (k, v) in dict {
//            x[Phylum(rawValue: k)!] = v
//        }
//        self._filterDict = State(initialValue: x)
//    }

//    func binding(key: Phylum) -> Binding<Bool> {
//        return .init(
//            get: { self.filterDict[key, default: true] },
//            set: {
//                self.filterDict[key] = $0
//
//                var x: [String : Bool] = [:]
//                Phylum.allCases.forEach { phylum in
//                    x[phylum.rawValue] = self.filterDict[phylum]
//                }
//                UserDefaults.standard.set(x, forKey: "filterDict")
//            }
//        )
//    }
