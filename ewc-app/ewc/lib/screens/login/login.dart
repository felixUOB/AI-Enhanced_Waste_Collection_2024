import 'package:ewc/imports/imports.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //TXT Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 120,),

//-------------RECYCLENXT LOGO----------------------

              const SizedBox(height: 50,),
              Image.asset(
                "assets/RecycleNXT-Logo_Update_Black.png",
                scale: 8,
                ),

//-------------WELCOME BACK TXT-FELILD----------------------

              const SizedBox(height: 50,),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontFamily: 'Questrial',
                  fontSize: 18,
                )
              ),

              const SizedBox(height: 30,),

//-------------USERNAME TXT-FEILD----------------------

              //username txtfld
              LoginTextfeild(
                controller: usernameController,
                hintText: "Username",
                
                obscured: false,
              ),

              const SizedBox(height: 10,),

//-------------PASSWORD TXT-FEILD----------------------

              LoginTextfeild(
                controller: passwordController,
                hintText: "Password",
                obscured: true,
              ),

//-------------HYPERLINK-------------------------------

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    HyperLinkText(
                      string1: "",
                      hyperString: "Forgot Password?", 
                      string2: "",
                      link: Uri.parse("https://en.wikipedia.org/wiki/Lamia"), // <- NEEDS TO LINK TO PASSWORD RESET FUNCTION
                      )
                  ],
                )
                ),

//-------------LOGIN BUTTON---------------------

              LoginButton(
                text1: "Sign In",
              ),
              const SizedBox(height: 10,),
            
//-------------HYPERLINK----------------------

              HyperLinkText(
                string1: "Not a member?", 
                hyperString: "Register Here.",
                string2: "",
                link: Uri.parse("https://spacenxtlabs.com"), // <- NEEDS TO LINK TO REGISTRATION FUNCTION
                ),
            ],
          ),
        ),
      ),
    );     
  }
}
