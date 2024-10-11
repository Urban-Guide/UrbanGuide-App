import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:urbun_guide/user_management/models/UserModel.dart';
import 'package:urbun_guide/user_management/screens/authentication/authenticate.dart';
import 'package:urbun_guide/user_management/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
