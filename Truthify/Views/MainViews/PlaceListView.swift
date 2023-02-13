//
//  PlaceListView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/11/23.
//

import SwiftUI
import CoreLocation

struct PlaceListView: View {
    
    @StateObject var vm = LocationViewModel()
    
    let landmarks: [Landmark]
    
    @Binding var search: String
    @Binding var location: CLLocationCoordinate2D?
    @Binding var verified: Bool
    @Binding var openListView: Bool
    @Binding var landmarkLocation: String
    @Binding var landmarkName: String
    @Binding var openVerificationView: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                ZStack {
                    HStack {
                        Image(systemName: "chevron.down")
                            .font(.title3)
                            .padding(.leading)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    HStack(spacing: 20) {
                        Spacer()
                        Text(search)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.black)
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 12)
            .frame(width: UIScreen.main.bounds.size.width, height: 60)
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(self.landmarks, id: \.id) { landmark in
                        VStack(spacing: 0) {
                            Button {
                                verifyLocation(landmark: landmark)
                            } label: {
                                VStack(spacing: 0) {
                                    HStack(spacing: 20) {
                                        ZStack {
                                            Image(systemName: "building.2.crop.circle")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 55, height: 55)
                                                .foregroundColor(Color(.label))
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(landmark.name)
                                                .font(.system(size: 17, weight: .semibold))
                                                .foregroundColor(Color(.label))
                                            Text(landmark.address)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color(.systemGray))
                                        }
                                    }
                                    .padding(.leading)
                                    .padding(.vertical, 12)
                                    .frame(width: UIScreen.main.bounds.width - 30)
                                }
                                .background {
                                    Color(.systemGray5)
                                        .cornerRadius(12)
                                }
                                .padding(8)
                            }
                            .buttonStyle(ButtonScaleStyle())
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    func verifyLocation(landmark: Landmark) {
        guard let location = self.location else {
            print("User location is nil")
            return
        }
        
        let distanceBetween = CLLocation.distance(from: location, to: landmark.coordinate)
        
        if distanceBetween < 100000 {
            self.verified = true
            self.openListView = false
            self.landmarkName = landmark.name
            let landmarkString = coordinateToString(coordinate: landmark.coordinate)
            self.landmarkLocation = landmarkString
            self.openVerificationView.toggle()
        } else {
            print("Not verified")
        }
    }
    
    func coordinateToString(coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        return "\(latitude)\(longitude)"
    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView(landmarks: [Landmark](), search: .constant("McDonald's"), location: .constant(CLLocationCoordinate2D(latitude: 425.45, longitude: 435.45)), verified: .constant(false), openListView: .constant(true), landmarkLocation: .constant(""), landmarkName: .constant("Mcdonalds"), openVerificationView: .constant(false))
    }
}
