//
//  AddNoteView.swift
//  Notes
//
//  Created by Alex Diaz on 8/7/23.
//

import SwiftUI

struct AddNoteView: View {
    
    @State var text = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        HStack {
            TextField("Write a note...", text: $text)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .clipped()
            
            Button {
                postNote()
            } label: {
                Text("Add")
            }
            .padding(8)

        }
    }
    
    func postNote() {
        print("POST")
        let params = ["note" : text] as [String:Any]
        let url = URL(string: "http://localhost:3000/notes")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        catch let error {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, res, err in
            guard err == nil else { return } //this is a comparison not delclaration
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            }
            catch let error {
                print(error)
            }
        }
        task.resume()
        
        self.text = ""
        dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
