//
//  Library.swift
//  iMusic
//
//  Created by CodergirlTM on 30.01.22.
//

import SwiftUI
import URLImage

struct Library: View {
    
    var tracks = UserDefaults.standard.savedTracks()
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            print("123456")
                        }, label: {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width/2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 1.0, green: 0.18, blue: 0.33, alpha: 1.0)))
                                .background(Color.init(#colorLiteral(red: 0.87, green: 0.90, blue: 0.91, alpha: 1.0)))
                                .cornerRadius(10)
                        })
                        Button(action: {
                            print("123456")
                        }, label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width/2 - 10, height: 50)
                                .accentColor(Color.init(#colorLiteral(red: 1.0, green: 0.18, blue: 0.33, alpha: 1.0)))
                                .background(Color.init(#colorLiteral(red: 0.87, green: 0.90, blue: 0.91, alpha: 1.0)))
                                .cornerRadius(10)
                        })
                    }
                    
                }
                .padding().frame(height: 70)
//                        Divider().padding(.trailing).padding(.trailing)
                List(tracks) { track in
                    LibraryCell(cell: track)
                }
            }
        .navigationBarTitle("Library")
            }
        }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            
            let url = URL(string: cell.iconUrlString ?? "")
//            URLImage(URL(string: cell.iconUrlString ?? "")).resizable().frame(width: 60, height: 60).cornerRadius(2)
            URLImage(url!) { image in
                image
                    .resizable()
                    .frame(width: 60,
                           height: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text("\(cell.trackName)")
                Text("\(cell.artistName)")
            }
        }
    }
}
        

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
