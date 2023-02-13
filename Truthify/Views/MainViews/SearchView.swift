//
//  SearchView.swift
//  Truthify
//
//  Created by Jacob Lucas on 1/14/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    
    @State var search: String = ""
    @State private var landmarks: [Landmark] = [Landmark]()
    @State var openComments: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                Text("Search")
                    .font(.system(size: 20, weight: .medium))
                HStack {
                    Button {
                        self.dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .frame(height: 48)
                    .foregroundColor(Color(.systemGray3))
                HStack(spacing: 0) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(.systemGray3))
                        .padding(.leading)
                    TextField("Enter the name of a business...", text: $search)
                        .padding(.horizontal)
                        .autocorrectionDisabled(true)
                        .autocorrectionDisabled(true)
                        .onChange(of: search) { _ in
                            getNearByLandmarks()
                        }
                    Spacer(minLength: 0)
                    Image(systemName: "xmark.circle.fill")
                        .padding(.trailing)
                        .foregroundColor(Color(.systemGray))
                        .opacity(search == "" ? 0.0 : 1.0)
                        .onTapGesture {
                            self.search = ""
                            
                        }
                }
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(self.landmarks, id: \.id) { landmark in
                            VStack(spacing: 0) {
                                NavigationLink {
                                    let businessID = coordinateToString(coordinate: landmark.coordinate)
                                    LandmarkView(posts: ReviewArrayObject(businessID: businessID), landmarkName: landmark.name, landmarkAddress: landmark.address, openComments: $openComments)
                                } label: {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(landmark.name)
                                                    .font(.system(size: 17, weight: .semibold))
                                                    .foregroundColor(Color(.label))
                                                Text(landmark.address)
                                                    .font(.system(size: 15))
                                                    .foregroundColor(Color(.systemGray))
                                                    .lineLimit(1)
                                            }
                                            Spacer(minLength: 0)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        .frame(width: UIScreen.main.bounds.width - 30)
                                    }
                                    .background {
                                        Color(.systemGray6)
                                            .cornerRadius(8)
                                    }
                                    .padding(8)
                                }
                                .buttonStyle(ButtonScaleStyle())
                            }
                        }
                }
            }
        }
        .navigationBarHidden(true)
        .frame(width: UIScreen.main.bounds.width - 30)
    }
    
    func coordinateToString(coordinate: CLLocationCoordinate2D) -> String {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        return "\(latitude)\(longitude)"
    }
    
    private func getNearByLandmarks() {
        
        let region = MKCoordinateRegion()
        
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
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
