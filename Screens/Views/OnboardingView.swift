import SwiftUI
import FirebaseAuth


struct OnboardingView: View {
  
  @Environment(\.presentationMode) private var presentationMode
  
  @State private var isOnboardingPart2Displayed: Bool = false
  @State var showError: Bool = false
  @State var errorMessage: String? = nil
  @State var isLoading: Bool = false
  
  @State private var displayName: String = ""
  @State private var email: String = ""
  @State private var providerID: String = ""
  @State private var provider: String = ""
  
  
  var body: some View {
    VStack(spacing: 10) {
      
      Image("logo.transparent")
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100, alignment: .center)
        .shadow(radius: 12)
      
      Text("Welcome to CatGram!")
        .font(.title)
        .fontWeight(.semibold)
        .foregroundColor(Color.MyTheme.pinkColor)
      
      Text("CatGram is the #1 app for posting pictures of your cat and sharing them across the world. We are a cat-loving community and we're happy to welcome you!")
            .font(.body)
        .multilineTextAlignment(.center)
        .foregroundColor(.primary)
        .padding()
      
//      Button(action: {
//        isOnboardingPart2Displayed.toggle()
//      }) {
//        SignInWithAppleButton()
//          .frame(height: 60)
//          .frame(maxWidth: .infinity)
//      }
//      
      Button(action: {
        SignInWithGoogle.shared.signIn(view: self)
      }) {
        HStack {
          Image(systemName: "globe")
          
          Text("Sign in with Google")
          
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
        .cornerRadius(6)
        .font(.title3)
        
      }
      .accentColor(.white)
      
      Button(action: {
        presentationMode.wrappedValue.dismiss()
      }) {
        Text("Continue as guest".uppercased())
          .font(.headline)
          .fontWeight(.medium)
          .padding()
      }
      .accentColor(.secondary)
      
      
    }
    .padding(20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.MyTheme.yourColor)
    .edgesIgnoringSafeArea(.all)
    .fullScreenCover(isPresented: $isOnboardingPart2Displayed, onDismiss: {
      // dismiss the current view
      self.presentationMode.wrappedValue.dismiss()
    }) {
      OnboardingViewPart2(displayName: $displayName, email: $email, providerID: $providerID, provider: $provider)
    }
    .alert(isPresented: $showError) {
      return Alert(title: Text("Error Signing in"), message: Text(errorMessage ?? "Unexpected error courred when signing in"))
    }
  }
}


extension OnboardingView {
  
  func connectToFirebase(name: String, email: String, provider: String, credential: AuthCredential) {
    
    AuthService.shared.loginUserToFirebase(credential: credential) { providerID, isError, errorMessage, isNewUser, userID in
      
      if let isNewUser = isNewUser {
        
        if isNewUser {
          // new user
          if let providerID = providerID, !isError {
            // success - set the variables for new user
            self.displayName = name
            self.email = email
            self.providerID = providerID
            self.provider = provider
            
            // go onto the onboarding view part 2 for new user
            self.isOnboardingPart2Displayed.toggle()
            
          } else {
            // error exists - getting provider id
            print(errorMessage ?? "Error getting provider ID from log in user  to Firebase")
            self.errorMessage = errorMessage
            self.showError.toggle()
          }
          
        } else {
          // already existing user
          if let userID = userID {
            // success log into app directly
            AuthService.shared.loginUserToApp(userID: userID) { success in
              if success {
                // dismiss onboarding screen
                self.presentationMode.wrappedValue.dismiss()
              } else {
                print(errorMessage ?? "Error log in existing user into our app")
                self.errorMessage = errorMessage
                self.showError.toggle()
              }
            }
            
          } else {
            // there is an error getting user id for an existing user
            print(errorMessage ?? "Error getting ID from existing user to Firebase")
            self.errorMessage = errorMessage
            self.showError.toggle()
          }
        }
      } else {
        // error exists
        print(errorMessage ?? "Error getting  into from log in user to Firebase")
        self.errorMessage = errorMessage
        self.showError.toggle()
      }
    }
  }
}



struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
