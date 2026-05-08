import SwiftUI

struct MoodCircleView: View {
    let mood: MoodType
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(mood.backgroundColor)
                    .frame(width: 78, height: 78)
                    .overlay {
                        if isSelected {
                            Circle()
                                .strokeBorder(Color.solaceInk900, lineWidth: 3)
                                .shadow(color: Color.solaceTerra50, radius: 5)
                                .shadow(color: Color.solaceInk900.opacity(0.12), radius: 20, x: 0, y: 8)
                        }
                    }
                    .shadow(
                        color: Color.solaceInk900.opacity(isSelected ? 0 : 0.06),
                        radius: 12,
                        x: 0,
                        y: 4
                    )

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.solaceInk900)
                            .frame(width: 22, height: 22)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .scaleEffect(scale)
            .animation(.spring(response: 0.15, dampingFraction: 0.6), value: isSelected)

            Text(mood.displayName)
                .font(.newsreader(15, weight: isSelected ? .medium : .regular))
                .foregroundColor(.solaceInk900)
        }
        .onTapGesture {
            withAnimation {
                scale = 0.9
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.15)) {
                    scale = 1.0
                }
                onSelect()
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        MoodCircleView(mood: .calm, isSelected: true, onSelect: {})
        MoodCircleView(mood: .tender, isSelected: false, onSelect: {})
    }
    .padding()
    .background(Color.solaceTerra50)
}
