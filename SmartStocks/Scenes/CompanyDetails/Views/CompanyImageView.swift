//
//  CompanyImageView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-03.
//

import SwiftUI
import SwiftSVG

// SVGView doesn't hav a mac implementation.
#if os(iOS)
private struct SVGImageView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> SVGView {
        SVGView(svgData: data)
    }

    func updateUIView(_ uiView: SVGView, context: Context) {}
}
#endif

struct CompanyImageView: View {
    let url: URL?
    @State private var svgData: Data?
    
    var body: some View {
        Group {
            if url?.path.contains("AAPL") ?? false {
                Image(systemName: "apple.logo")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            } else {
                Group {
                    if let svgData {
                        #if os(iOS)
                        SVGImageView(data: svgData)
                        #endif
                    } else {
                        Image(systemName: "building.2.crop.circle")
                            .resizable()
                            .scaledToFit()
                    }
                }
                #if os(iOS)
                .task {
                    guard let url else { return }
                    svgData = try? await URLSession.shared.data(from: url).0
                }
                #endif
            }
        }
        // SVG's from finnhub seems to have a size of 56x56.
        .frame(width: 56, height: 56)
        .clipShape(Circle())
    }
}

//struct CompanyImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CompanyImageView()
//    }
//}
