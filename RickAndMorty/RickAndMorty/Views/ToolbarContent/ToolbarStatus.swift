import SwiftUI

struct ToolbarStatus: View {
    var isLoading: Bool
    var lastUpdated: TimeInterval
    var charactersCount: Int

    var body: some View {
        VStack {
            if isLoading {
                Text("Checking for Characters...")
                Spacer()
            } else if lastUpdated == Date.distantFuture.timeIntervalSince1970 {
                Spacer()
                Text("\(charactersCount) Characters")
                    .foregroundStyle(Color.secondary)
            } else {
                let lastUpdatedDate = Date(timeIntervalSince1970: lastUpdated)
                Text("Updated \(lastUpdatedDate.formatted(.relative(presentation: .named)))")
                Text("\(charactersCount) Characters")
                    .foregroundStyle(Color.secondary)
            }
        }
        .font(.caption)
    }
}

struct ToolbarStatus_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarStatus(
            isLoading: true,
            lastUpdated: Date.distantPast.timeIntervalSince1970,
            charactersCount: 125
        )
        .previewLayout(.fixed(width: 200, height: 40))

        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.distantFuture.timeIntervalSince1970,
            charactersCount: 10_000
        )
        .previewLayout(.fixed(width: 200, height: 40))

        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.now.timeIntervalSince1970,
            charactersCount: 10_000
        )
        .previewLayout(.fixed(width: 200, height: 40))

        ToolbarStatus(
            isLoading: false,
            lastUpdated: Date.distantPast.timeIntervalSince1970,
            charactersCount: 10_000
        )
        .previewLayout(.fixed(width: 200, height: 40))

    }
}
