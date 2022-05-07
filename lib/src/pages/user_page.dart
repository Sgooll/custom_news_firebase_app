import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lichi_test/src/pages/single_news_page.dart';

import '../authentication/authentication_service.dart';
import '../cubit/user_cubit.dart';
import '../widgets/news_widget.dart';


class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCubit(),
      child: _UserPage(),
    );
  }
}

class _UserPage extends StatefulWidget {

  @override
  State<_UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<_UserPage> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state){
      if (state is UserInitial){
        context.read<UserCubit>().informInitial();
        context.read<UserCubit>().loadFavouriteNews();
        return Scaffold(
            backgroundColor: Colors.black54,
            body: const Center(child: CircularProgressIndicator())
        );
      }
      if (state is UserErrorState){
        return Text("Error ${state.errorMessage}", style: const TextStyle(color: Colors.red));
      }
      if (state is UserLoadedState) {
        return RefreshIndicator(
          onRefresh: () => context.read<UserCubit>().reloadUser(),
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text("Your email: ${FirebaseAuth.instance.currentUser?.email}", style: const TextStyle(fontSize: 24)),
                  ElevatedButton(
                      onPressed: () => context.read<AuthenticationService>().signOut(),
                      child: const Text("Sign out")),
                  const Text("Your favourite news:"),
                  state.favouriteNewsList.isNotEmpty ? ListView.builder(
                      itemCount: state.favouriteNewsList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SingleNewsPage(item: state.favouriteNewsList[index]))),
                        child: NewsWidget(item: state.favouriteNewsList[index]));
                      }
                  ) : const Text("No favourites"),
                ],
              ),
            ),

          ),
        );
      }
      return Container();
    });
  }
}