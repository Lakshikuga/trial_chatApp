import 'package:chat_app_tutorial/helper/helperFunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRooms_screen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import "package:flutter/material.dart";


class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //back end
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();


  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };
      
      HelperFunctions.saveUserNameSharedPreferences(userNameTextEditingController.text);
      HelperFunctions.saveUserEmailSharedPreferences(emailTextEditingController.text);


      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((val) {
        //print(${val.uId});

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreferences(true);

        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => ChatRoom()
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: appBarMain(context),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator()),
        ) : SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 2 ? "Please enter a valid username" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("username"),
                      ),
                      TextFormField(
                        validator: (val ){
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val) ? null : "Please provide a valid emailId";
                        },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email"),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (val){
                              return val.length > 6 ? null : "Please provide password 6+ characters";
                            },
                          controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                  SizedBox(height :8),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child:Text("Forgot Password?", style:simpleTextStyle(),)
                    ),
                  ),
                  SizedBox(height:8,),
                  GestureDetector(
                    onTap: (){
                      signMeUp();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical:16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A758C),
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text("Sign Up", style: mediumTextStyle(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical:16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text("Sign Up with Google", style: TextStyle(
                      color:Colors.black87,
                      fontSize: 17,
                    ),
                    ),
                  ),
                  SizedBox(height:16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children :[
                      Text("Already have an account? ", style: simpleTextStyle(),),
                      GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text("SignIn now", style:TextStyle(
                            color:Colors.white,
                            //fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        )
    );
  }
}
