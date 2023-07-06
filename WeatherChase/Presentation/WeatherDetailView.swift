//
//  WeatherDetailView.swift
//  WeatherChase
//
//  Created by Kyle Watson on 7/6/23.
//

import UIKit

class WeatherDetailView: UIView {

}

import SwiftUI

struct WeatherDetailViewx: View {
    var body: some View {
        ScrollView {
            Text("Atlanta").font(.largeTitle)
            Text("70º F")
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailViewx()
    }
}
