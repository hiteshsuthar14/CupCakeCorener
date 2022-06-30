/*
 Day 49
 
                    func loadData() async {
                    }
 
By async keyword in there – we’re telling Swift this function might want to go to sleep in order to complete its work. “this work will take some time, so please wait for it to complete while the rest of the app carries on running as usual.”
 
 We cant use onAppear method for them so we need other method called "task"
    & those functions which can sleep.. we have to mark them ""await""
 
                    .task {
                        await loadData()
                    }
 
 
            func loadData() async {
                guard let url = URL(string: "https://example.com") else {
                    print("Invalid URL")
                    return
                }
            }
 
 
             do {
                 let (data, _) = try await URLSession.shared.data(from: url)

                 // more code to come
             } catch {
                 print("Invalid data")
             }
 
 Using do catch for other errors(eg Internet disconnect).
 Try for failure while storing the data.
 URLSession.shared is Class and its property for basic download request (not customized download request).
 .data(from:url) method takes url and returns data tuple
 (data, _) tuple means store the data and ignore the meta data
 
 
 
 
 */
