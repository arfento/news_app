import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_news/core/themes.dart';
import 'package:flutter_news/data/models/news_model.dart';
import 'package:flutter_news/data/models/source_model.dart';
import 'package:flutter_news/presentation/bloc/news_bloc/news_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'di/injection_container.dart' as di;
import 'presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  Hive.registerAdapter(SourceModelAdapter());
  await di.init();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsBloc>(
          create: (context) => di.sl<NewsBloc>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter News',
        debugShowCheckedModeBanner: false,
        theme: Themes.appTheme,
        home: const HomePage(),
      ),
    );
  }
}
