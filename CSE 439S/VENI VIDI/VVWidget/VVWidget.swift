//
//  VVWidget.swift
//  VVWidget
//
//  Created by MonAster on 2021/5/1.
//

import Intents
import SwiftUI
import WidgetKit

// MARK: - Provider

struct Provider: IntentTimelineProvider {
    func placeholder(in _: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "", cover: UIImage(named: "logo_background")!, configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in _: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), title: "", cover: UIImage(named: "logo_backgruond")!, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in _: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        let userDefault = UserDefaults(suiteName: "group.BEST-CSE439S-GROUP.VENI-VIDI.widget")
        let title = userDefault?.value(forKey: "title") as? String ?? "Fake Title"
        let coverImageData = userDefault?.value(forKey: "cover") as? Data ?? Data()
        let coverImage = UIImage(data: coverImageData) ?? UIImage(named: "logo_background")!

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            guard let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) else { continue }
            let entry = SimpleEntry(date: entryDate, title: title, cover: coverImage, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK: - SimpleEntry

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let cover: UIImage
    let configuration: ConfigurationIntent
}

// MARK: - RatioModifier

struct RatioModifier: ViewModifier {

    let ratio: CGFloat

    init(ratio: CGFloat) {
        self.ratio = ratio
    }

    func body(content: Content) -> some View {
        GeometryReader { _ in
            content
                .aspectRatio(contentMode: .fill)
        }
        .aspectRatio(ratio, contentMode: .fit)
    }
}

extension Image {
    func ratioImage(ratio: CGFloat) -> some View {
        modifier(RatioModifier(ratio: ratio))
    }

    func squareImage() -> some View {
        ratioImage(ratio: 1.0)
    }
}

// MARK: - VVWidgetEntryView

struct VVWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 15, style: .circular)

                    .padding(.all, 7)
                    .foregroundColor(Color(.displayP3, red: 1.0, green: 0.98, blue: 0.945, opacity: 1))
                ZStack {
                    Image(uiImage: entry.cover)
                        .resizable()
                        .squareImage()
                        .cornerRadius(15)

                        .frame(width: geo.size.width - 14, height: geo.size.height - 14, alignment: .center)
                        .clipped()
                        .padding(.trailing, 12)
                        .opacity(0.5)
                    Image(uiImage: entry.cover)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .frame(width: geo.size.width, height: geo.size.height - 24)
                        .padding(.trailing, 12)
                        .padding(.vertical, 12)
                }
            }
        }
    }
}

// MARK: - VVWidget

@main
struct VVWidget: Widget {
    let kind: String = "VVWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            VVWidgetEntryView(entry: entry)
                .background(Color("WidgetBackground"))
        }
        .configurationDisplayName("VENI VIDI")
        .description("This is a VENI VIDI widget. ")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - VVWidget_Previews

struct VVWidget_Previews: PreviewProvider {
    static var previews: some View {
        VVWidgetEntryView(entry: SimpleEntry(date: Date(), title: "Title", cover: UIImage(named: "logo_background")!, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
