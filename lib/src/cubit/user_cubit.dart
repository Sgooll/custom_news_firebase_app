import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../api/requests.dart';
import '../models/news.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> informInitial() async {
    print('UserPage loading');
  }

  Future<void> loadFavouriteNews() async {
    try{
      CollectionReference favourites = FirebaseFirestore.instance.collection("Favourites");
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      final docFav = favourites.doc(uid);
      var snapshot = await docFav.get();
      if (snapshot.exists){
        Map<String, dynamic> documentData = snapshot.data() as Map<
            String,
            dynamic>;
      emit(UserLoadedState(await getFavouriteNews(documentData["favouritesId"])));
      print('User loaded');
    }
      else {
        List<News> list = [];
        emit(UserLoadedState(list));
      }
    }catch (e){
      emit(UserErrorState('Failed User Load $e'));
    }
  }

  Future<void> reloadUser() async {
    emit(UserInitial());
  }

}
