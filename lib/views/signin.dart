import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tineviland/Widgets/widget.dart';
import 'signup.dart';
import 'forgetpassword.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  firebase_auth.FirebaseAuth firebaseAuth =  firebase_auth.FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        //Redraw so that the username label reflects the focus state
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        //Redraw so that the password label reflects the focus state
      });
    });
  }

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _unfocusedColor = Colors.grey[600];
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isObscurePassword = true;
  bool circular = false;
  Widget build(BuildContext context) {
    return Scaffold(
        appBar : AppBar(),
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              children: <Widget>[
                Column(children: <Widget>[
                  const SizedBox(height: 120.0),
                  Image.asset(
                    'assets/Logo.png',
                    height: 150,
                  ),
                ]),
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Số điện thoại",
                    labelStyle: TextStyle(
                      color: _emailFocusNode.hasFocus
                          ? Theme.of(context).colorScheme.secondary
                          : _unfocusedColor,
                    ),
                  ),

                  validator: (value) {
                    if (value == "") {
                      return 'Vui lòng không được để trống số điện thoại!';
                    }

                    else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value!) || value.length > 10)
                      return "Vui lòng nhập số điện thoại hợp lệ!";

                    return null;
                  },
                  focusNode: _emailFocusNode,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      suffixIcon: IconButton(
                          icon: Icon(
                              _isObscurePassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscurePassword = !_isObscurePassword;
                            });
                          }),
                      labelStyle: TextStyle(
                        color: _passwordFocusNode.hasFocus
                            ? Theme.of(context).colorScheme.secondary
                            : _unfocusedColor,
                      )),
                  focusNode: _passwordFocusNode,
                  validator: (value) {
                    if (value=="") {
                      return 'Vui lòng không được bỏ trống mật khẩu';
                    } else {
                      if (value!.length < 8) {
                        return 'Vui lòng nhập mật khẩu dài ít nhất 8 kí tự  ';
                      } else {
                        return null;
                      }
                    }
                  },
                  obscureText: _isObscurePassword,
                ),
                const SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.centerRight,

                  child: Container(
                    child: TextButton(
                      child: Text(
                      'Quên mật khẩu?',
                      style: simpleTextFieltStyle()
                      ),
                      onPressed:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgetPassword()),
                        );
                      } ,

                    ),
                  ),
                ),

                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonMinWidth: 300,
                  children: <Widget>[
                    ElevatedButton(
                      child: circular ? CircularProgressIndicator( color: Colors.white,):  const Text('Đăng nhập' ,
                          style:TextStyle(
                            color: Colors.white,
                          )

                      ),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(8.0),

                        shape: MaterialStateProperty.all(
                          const BeveledRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(3.0)),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          circular = true;
                        });
                        try {
                          if (_formKey.currentState!.validate()) {
                            firebase_auth.UserCredential userCredential = await firebaseAuth
                                .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                            print(userCredential.user!.email);
                            setState(() {
                              circular = false;
                            });
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (builder)=>SignIn()),
                                    (route) => false);
                          }
                        } catch (e){
                          final snackbar = SnackBar(content : Text(e.toString()));
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          setState(() {
                            circular = false;
                          });
                        }
                      },
                    ),
                    TextButton(
                      child: const Text('Quay lại'),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        shape: MaterialStateProperty.all(
                          const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _emailController.clear();
                        _passwordController.clear();
                      },
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment : MainAxisAlignment.center ,
                  children: [
                    Text(
                    'Chưa có tài khoản !',
                    style: simpleTextFieltStyle(),
                  ),

                    TextButton(
                        child: const Text("Đăng ký ngay",
                            style : TextStyle(
                                  fontSize: 14,
                                decoration: TextDecoration.underline
                            )),

                      onPressed:()=>{
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                      )
                      },

                    )
                  ]
                ),

              ],
            )));
  }

}
