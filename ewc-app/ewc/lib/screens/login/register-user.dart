import 'package:ewc/imports/imports.dart';

class RegisterUser extends StatelessWidget {
  RegisterUser({super.key});

  //TXT Controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
            
//-------------RECYCLENXT LOGO----------------------
            
                  const SizedBox(height: 170,),
                  Image.asset(
                    "assets/RecycleNXT-Logo_Update_Black.png",
                    scale: 8,
                    ),
            
//-------------WELCOME BACK TXT-FELILD----------------------
            
                  const SizedBox(height: 50,),
                  Text(
                    "Register!",
                    style: Theme.of(context).textTheme.bodyLarge,
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
            
//-------------LOGIN BUTTON---------------------------------
            
                  LoginButton(
                    text1: "Sign Up",
                  ),
                  const SizedBox(height: 10,),
                
//-------------HYPERLINK-------------------------------------
                
                  HyperLinkText(
                    string1: "Already a user?", 
                    hyperString: "Login In Here.",
                    string2: "",
                    link: Uri.parse("https://spacenxtlabs.com"), // <- NEEDS TO LINK TO LOGIN PAGE
                    ),
                ],
              ),
            ),
//----------------THEME SWITCH------------------------------
            // ignore: prefer_const_constructors
            Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const SizedBox(height: 20,),
                // ignore: prefer_const_constructors
                Padding(
                  padding: const EdgeInsets.all(25),
                  child:
                    // ignore: prefer_const_constructors
                    Align(
                      alignment: Alignment.topRight, 
                      // ignore: prefer_const_constructors
                      child: ThemeSwitch(),
                    )
                )
          ],)
        ]),
    )
    );     
  }
}
