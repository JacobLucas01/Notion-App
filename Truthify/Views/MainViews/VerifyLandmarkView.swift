//
//  VerifyBusinessView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/11/23.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreLocationUI

struct VerifyLandmarkView: View {
    
    @State private var isLoading: Bool = false
    @State private var search: String = ""
    @State private var landmarks: [Landmark] = [Landmark]()
    @State private var tapped: Bool = false
    @Binding var verified: Bool
    @Binding var landmarkLocation: String
    @Binding var landmarkName: String
    @Binding var openVerificationView: Bool
    
    @State var location: CLLocationCoordinate2D? = nil
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack {
                    Text("Verify Business")
                        .font(.system(size: 18, weight: .semibold))
                    HStack {
                        Button {
                            openVerificationView.toggle()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                        }
                        .buttonStyle(ButtonScaleStyle())
                        Spacer()
                    }
                }
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 30)
                Divider()
                HStack {
                    Text("Why do we require this step?")
                    Image(systemName: "info.circle")
                }
                .font(.system(size: 15))
                .foregroundColor(Color(.systemGray2))
                .padding(.vertical)
                Spacer()
                    Text("Press 'Current Location' and enter the name of the business in the search bar. Then, select the correct business that appears.")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.systemGray2))
                        .padding(.vertical, 12)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width - 30)
                .ignoresSafeArea(.keyboard)            }
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(height: 48)
                        .foregroundColor(Color(.systemGray3))
                    HStack {
                        TextField("What's the business name?", text: $search)
                        .padding(.horizontal)
                        if isLoading {
                            ProgressView()
                                .padding(.trailing)
                        } else {
                            Button {
                                self.getNearByLandmarks()
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .padding(.trailing)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                VStack(alignment: .trailing, spacing: 0) {
                    MapView(landmarks: landmarks)
                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)
                        .cornerRadius(8)
                        .padding(.vertical)
                    LocationButton {
                        locationManager.requestLocation()
                    }
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .cornerRadius(.infinity)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 30)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $tapped) {
            PlaceListView(landmarks: self.landmarks, search: $search, location: $location, verified: $verified, openListView: $tapped, landmarkLocation: $landmarkLocation, landmarkName: $landmarkName, openVerificationView: $openVerificationView)
        }
    }
    
    private func getNearByLandmarks() {
        
        self.isLoading = true
        
        var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: locationManager.loc.latitude, longitude: locationManager.loc.longitude)
        
        self.location = locationManager.loc
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            if let response = response {
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
            }
            
            if let error = error {
                print("Error searching for nearby businesses. \(error)")
                self.isLoading = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.tapped = true
        }
    }
}

struct VerifyLandmarkView_Previews: PreviewProvider {
    static var previews: some View {
        VerifyLandmarkView(verified: .constant(false), landmarkLocation: .constant(""), landmarkName: .constant(""), openVerificationView: .constant(false))
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    @Published var loc = CLLocationCoordinate2D()

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        self.loc = location
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location data.")
    }

}
