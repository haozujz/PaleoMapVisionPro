//////
//////  GlovesView.swift
//////  PaleoMapVisionPro
//////
//////  Created by Joseph Zhu on 21/11/2023.
//////
////
//import SwiftUI
//import RealityKit
//
//struct GlovesView: View {
//    @Environment(ImmersiveModel.self) private var immersiveModel
//    
//    var body: some View {
//        RealityView { content in
//            let root = Entity()
//            content.add(root)
//
//            // Load Left glove
//            let leftGlove = try! Entity.loadModel(named: "assets/gloves/LeftGlove_v001.usdz")
//            root.addChild(leftGlove)
//
//            // Load Right glove
//            let rightGlove = try! Entity.loadModel(named: "assets/gloves/RightGlove_v001.usdz")
//            root.addChild(rightGlove)
//
//            // Start ARKit session and fetch anchorUpdates
//            Task {
//                do {
//                    try await immersiveModel.arSession.run([immersiveModel.handTracking])
//                } catch let error {
//                    print("Encountered an unexpected error: \(error.localizedDescription)")
//                }
//                for await anchorUpdate in immersiveModel.handTracking.anchorUpdates {
//                    let anchor = anchorUpdate.anchor
//                    switch anchor.chirality {
//                    case .left:
//                        if let leftGlove = Entity.leftHand {
//                            leftGlove.transform = Transform(matrix: anchor.transform)
//                            for (index, jointName) in anchor.skeleton.definition.jointNames.enumerated() {
//                                leftGlove.jointTransforms[index].rotation = simd_quatf(anchor.skeleton.joint(named: jointName).localTransform)
//                            }
//                        }
//                    case .right:
//                        if let rightGlove = Entity.rightHand {
//                            rightGlove.transform = Transform(matrix: anchor.transform)
//                            for (index, jointName) in anchor.skeleton.definition.jointNames.enumerated() {
//                                rightGlove.jointTransforms[index].rotation = simd_quatf(anchor.skeleton.joint(named: jointName).localTransform)
//
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
////
//////#Preview {
//////    GlovesView()
//////}
//
//
////.gesture(TapGesture().targetedToAnyEntity().onEnded { value in
////    var transform = value.entity.transform
////    transform.translation += SIMD3(0.1, 0, -0.1)
////    value.entity.move(
////        to: transform,
////        relativeTo: nil,
////        duration: 3,
////        timingFunction: .easeInOut
////    )
////})
