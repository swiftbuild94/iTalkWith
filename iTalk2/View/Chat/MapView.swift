//
//  MapView.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 13/07/2022.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -34.603722, longitude: -58.381592),
        span: MKCoordinateSpan(latitudeDelta: 0.0001, longitudeDelta: 0.0001)
    )
    @ObservedObject private var locationManager = LocationManager()
    @ObservedObject var vmChat: ChatsVM
    
    private var homeLocation : [AnnotationItem] {
          guard let location = locationManager.location?.coordinate else {
              return []
          }
          return [.init(name: "Home", coordinate: location)]
      }
      
    var body: some View {
        NavigationView {
            Map(
                coordinateRegion: $locationManager.region,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode,
                annotationItems: homeLocation
            ) {
                MapPin(coordinate: $0.coordinate, tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
            //.navigationTitle("Your location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        vmChat.shouldShowLocation = false
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.accentColor)
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        vmChat.shouldShowLocation = false
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Send Location")
                            .foregroundColor(Color.accentColor)
                    }
                }
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatUser: userTest)
    }
}
