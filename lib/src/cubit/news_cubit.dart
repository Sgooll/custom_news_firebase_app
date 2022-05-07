import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../api/requests.dart';
import '../models/news.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsInitial());

  Future<void> informInitial() async {
    print('NewsPage loading');
  }

  Future<void> loadNews() async {
    try{
      emit(NewsLoadedState(await getNews(), "No filter"));
      print('News loaded');
    }catch (e){
      emit(NewsErrorState('Failed News Load $e'));
    }
  }

  Future<void> reloadNews() async {
    emit(NewsInitial());
  }

}
