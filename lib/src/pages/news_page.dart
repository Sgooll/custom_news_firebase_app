import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lichi_test/src/pages/edit_news_page.dart';
import 'package:lichi_test/src/pages/single_news_page.dart';
import 'package:provider/provider.dart';
import '../cubit/news_cubit.dart';
import '../widgets/news_widget.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewsCubit(),
      child: _NewsPage(),
    );
  }
}

class _NewsPage extends StatefulWidget {
  _NewsPage({Key? key}) : super(key: key);
  Object? _dropdownValue = "No filter";

  @override
  State<_NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<_NewsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsCubit, NewsState>(builder: (context, state){
      if (state is NewsInitial){
        context.read<NewsCubit>().informInitial();
        context.read<NewsCubit>().loadNews();
        return Scaffold(
            backgroundColor: Colors.black54,
            body: const Center(child: CircularProgressIndicator())
        );
      }
      if (state is NewsErrorState){
        return Text("Error ${state.errorMessage}", style: const TextStyle(color: Colors.red));
      }
      if (state is NewsLoadedState) {
        if (widget._dropdownValue == "No filter")state.newsList.sort((a, b) {return a.id.compareTo(b.id);});
        if (widget._dropdownValue == "Date")state.newsList.sort((a, b) {return a.date.compareTo(b.date);});
        if (widget._dropdownValue == "Favourites")state.newsList.sort((a, b) {return b.favourite.length.compareTo(a.favourite.length);});
        return RefreshIndicator(
          onRefresh: () => context.read<NewsCubit>().reloadNews(),
          backgroundColor: Colors.black,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButton(
                      items: const [
                        DropdownMenuItem(child: Text("No filter"), value: "No filter"),
                        DropdownMenuItem(child: Text("Filter by date"), value: "Date"),
                        DropdownMenuItem(child: Text("Filter by favourites"), value: "Favourites"),
                      ],
                      value: widget._dropdownValue,
                      onChanged: (value) => setState(() {
                        widget._dropdownValue = value;
                        context.read<NewsCubit>().reloadNews();
                      })
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EditNewsPage())),
                      child: const Text("Add news")),
                  ListView.builder(
                      itemCount: state.newsList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => SingleNewsPage(item: state.newsList[index]))),
                            child: NewsWidget(item: state.newsList[index])
                        );
                      }
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey,
          ),
        );
  }
      return Container();
  });
  }
}