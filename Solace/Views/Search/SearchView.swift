import SwiftUI
import SwiftData

struct SearchView: View {
    @Query(sort: \Entry.date, order: .reverse) private var entries: [Entry]
    @State private var query = ""
    @State private var activeTags: Set<String> = []

    private var allTags: [String] {
        Array(Set(entries.flatMap(\.tags))).sorted()
    }

    private var results: [Entry] {
        guard !query.isEmpty || !activeTags.isEmpty else { return [] }
        return entries.filter { entry in
            let matchesQuery = query.isEmpty ||
                entry.title.localizedCaseInsensitiveContains(query) ||
                entry.body.localizedCaseInsensitiveContains(query)
            let matchesTags = activeTags.isEmpty ||
                activeTags.allSatisfy { entry.tags.contains($0) }
            return matchesQuery && matchesTags
        }
    }

    var body: some View {
        ZStack {
            Color.solaceBgCream.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Spacer().frame(width: 60)
                    Spacer()
                    Text("Search")
                        .font(.newsreader(17, weight: .medium))
                        .foregroundColor(.solaceInk900)
                    Spacer()
                    Spacer().frame(width: 60)
                }
                .padding(.top, 46)

                // Search field
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(.solaceInk500)

                    TextField("Search your journal…", text: $query)
                        .font(.mulish(15, weight: .medium))
                        .foregroundColor(.solaceInk900)

                    if !query.isEmpty {
                        Button {
                            query = ""
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.solaceInk300)
                                    .frame(width: 18, height: 18)
                                Text("×")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.solaceBgPaper)
                .clipShape(RoundedRectangle(cornerRadius: Radius.card))
                .padding(.horizontal, 24)
                .padding(.top, 24)

                // Tag filter
                if !allTags.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("FILTER BY TAG")
                            .font(.mulish(11, weight: .bold))
                            .foregroundColor(.solaceInk500)
                            .tracking(1.6)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(allTags, id: \.self) { tag in
                                    let isActive = activeTags.contains(tag)
                                    Button {
                                        if isActive { activeTags.remove(tag) }
                                        else { activeTags.insert(tag) }
                                    } label: {
                                        Text(tag)
                                            .font(.mulish(12, weight: .semibold))
                                            .foregroundColor(isActive ? .solaceBgPaper : .solaceInk700)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(isActive ? Color.solaceInk900 : Color.solaceBgPaper)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                // Results
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        if !results.isEmpty {
                            Text("\(results.count) RESULT\(results.count == 1 ? "" : "S")")
                                .font(.mulish(11, weight: .bold))
                                .foregroundColor(.solaceInk500)
                                .tracking(1.6)
                                .padding(.horizontal, 24)
                                .padding(.top, 24)
                                .padding(.bottom, 12)

                            LazyVStack(spacing: 8) {
                                ForEach(Array(results.enumerated()), id: \.element.id) { index, entry in
                                    NavigationLink {
                                        EntryDetailView(entry: entry, entries: results, currentIndex: index)
                                    } label: {
                                        SearchResultCard(entry: entry, query: query)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal, 24)
                        } else if !query.isEmpty || !activeTags.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(.solaceInk300)
                                    .padding(.top, 60)
                                Text("No entries match your search.")
                                    .font(.newsreader(17, italic: true))
                                    .foregroundColor(.solaceInk500)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
    .modelContainer(for: [Entry.self], inMemory: true)
}
