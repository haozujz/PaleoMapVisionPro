//
//  ImmersiveView.swift
//  PaleoMapVisionPro
//
//  Created by Joseph Zhu on 25/10/2023.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(ImmersiveModel.self) private var immersiveModel
    
    @State private var scale = false
    
    var body: some View {
        RealityView { content in
            Task {
                await immersiveModel.runSession()
            }
            
            //let model = Model3D(named: "Scene", bundle: realityKitContentBundle)
            let entity = await immersiveModel.setupContentEntity(name: "Earth")
            entity.name = "Globe"
            
            // Position entity relative to head
            let anchor = AnchorEntity(.head)
            anchor.name = "Head Anchor"
            anchor.anchoring.trackingMode = .once
            anchor.addChild(entity)
            
            entity.transform.translation.y = 0.0
            entity.transform.translation.z = -1.0

            content.add(anchor)

            // Enable interactions on the entity.
            entity.components.set(InputTargetComponent())
            entity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.3)]))
        } update: { content in
            if let model = content.entities.first {
                model.transform.scale = scale ? [1.2, 1.2, 1.2] : [1.0, 1.0, 1.0]
            }
        }
        .simultaneousGesture(
            DragGesture()
                //.targetedToAnyEntity()
                .targetedToEntity(immersiveModel.contentEntity)
                .onChanged { value in
                    immersiveModel.contentEntity.position = value.convert(
                        value.location3D,
                        from: .local,
                        to: immersiveModel.contentEntity) //.parent!
                }
        )
        .simultaneousGesture(
            TapGesture()
                //.targetedToAnyEntity()
                .targetedToEntity(immersiveModel.contentEntity)
                .onEnded { value in
                    var transform = value.entity.transform
                    transform.translation += SIMD3(0.1, 0, -0.1)
                    value.entity.move(
                        to: transform,
                        relativeTo: nil,
                        duration: 2,
                        timingFunction: .easeInOut
                    )
                }
        )

    }
}

//#Preview {
//    ImmersiveView()
//        .previewLayout(.sizeThatFits)
//}

//RealityView { content in
//    // Add the initial RealityKit content
//    if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
//        content.add(immersiveContentEntity)
//
//        // Add an ImageBasedLight for the immersive content
//        guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
//        let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
//        immersiveContentEntity.components.set(iblComponent)
//        immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))
//
//        // Put skybox here.  See example in World project available at
//        // https://developer.apple.com/
//    }
//}
