//
//  CompanyImageView.swift
//  SmartStocks
//
//  Created by Tibor Felföldy on 2023-05-03.
//

import SwiftUI
import SwiftSVG

// SVGView doesn't have a mac implementation.
#if os(iOS)
private struct SVGImageView: UIViewRepresentable {
    let data: Data
    
    func makeUIView(context: Context) -> SVGView {
        SVGView(svgData: data)
    }

    func updateUIView(_ uiView: SVGView, context: Context) {}
}

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
                        SVGImageView(data: svgData)
                    } else {
                        Image(systemName: "building.2.crop.circle")
                            .resizable()
                            .scaledToFit()
                    }
                }
                .task {
                    guard let url else { return }
                    let data = try? await URLSession.shared.data(from: url).0
                    DispatchQueue.main.async {
                        self.svgData = data
                    }
                }
            }
        }
        // SVG's from finnhub seems to have a size of 56x56.
        .frame(width: 56, height: 56)
        .clipShape(Circle())
    }
}
#endif
