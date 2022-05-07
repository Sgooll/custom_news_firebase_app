import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../api/requests.dart';
import '../models/news.dart';

part 'single_news_state.dart';

class SingleNewsCubit extends Cubit<SingleNewsState> {
  SingleNewsCubit() : super(SingleNewsInitial());

  Future<void> informInitial() async {
    print('SingleNewsPage loading');
  }

  Future<void> loadSingleNews(String id) async {
    try{
      emit(SingleNewsLoadedState(await getOneNews(id)));
      print('Single News loaded');
    }catch (e){
      emit(SingleNewsErrorState('Failed Single News Load $e'));
    }
  }

  Future<void> reloadSingleNews() async {
    emit(SingleNewsInitial());
  }

}
