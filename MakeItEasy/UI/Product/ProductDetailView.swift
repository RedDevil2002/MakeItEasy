//
//  ProductDetailView.swift
//  MakeItEasy
//
//  Created by Brian Seo on 2023-06-13.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var viewModel: ProductViewModel
    @AppStorage("itemIDs") private var itemIDs: [String] = []
    
    let priceChangeLogManager = PriceChangeLogManager()
    
    @State private var sources: [String] = []
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                TextField("", text: $viewModel.itemID)
                Spacer()
            }
            TabView {
                ForEach(sources, id: \.self) { link in
                    VStack {
                        AsyncImage(url: URL(string: link)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                        } placeholder: {
                            ProgressView()
                        }
                        Text(link)
                    }
                }
            }
            .onReceive(viewModel.$itemID) { newItemID in
                sources = viewModel.sources
            }
            .task {
                await priceChangeLogManager.parseProductObjectFile(forResource: "productInfos", withExtension: "json")
                if viewModel.sources.isEmpty {
                    viewModel.itemID = findClosestString(itemIDs, viewModel.itemID) ?? viewModel.itemID
                    print(itemIDs)
                }
            }
        }
        .tabViewStyle(.page)
    }
}

extension ProductDetailView {
    private func findClosestString(_ A: [String], _ X: String) -> String? {
        var closestDistance = Int.max
        var closestString: String?

        for string in A {
            let distance = levenshteinDistance(string, X)
            if distance < closestDistance {
                closestDistance = distance
                closestString = string
            }
        }

        return closestString
    }

    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let m = s1.count
        let n = s2.count

        var dp = [[Int]](repeating: [Int](repeating: 0, count: n + 1), count: m + 1)

        for i in 0...m {
            dp[i][0] = i
        }

        for j in 0...n {
            dp[0][j] = j
        }

        let s1Array = Array(s1)
        let s2Array = Array(s2)

        for i in 1...m {
            for j in 1...n {
                if s1Array[i - 1] == s2Array[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    dp[i][j] = min(dp[i - 1][j - 1], dp[i][j - 1], dp[i - 1][j]) + 1
                }
            }
        }

        return dp[m][n]
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: ProductViewModel = ProductViewModel(itemID: "585")
        ProductDetailView()
            .environmentObject(viewModel)
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
