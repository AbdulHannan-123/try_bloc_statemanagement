import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

const names = ['hannan', 'sarim', ' zain',];

extension RandomElement<T> on Iterable<T>{  // allow us to call 1 iterable function
  T getRandomElement() => elementAt(       // 1 is element at 
    math.Random().nextInt(length)
  );
}

class NameCubit extends Cubit<String?> {    // the need an state
 NameCubit() : super(null) ;            //i dont ahve the n=initial state     // you need the initial value har coded to give that a state   

  void pickRandomName() => emit(names.getRandomElement());   //get the value from extention we created

}


class HomePage extends StatefulWidget {         // making statefull so we can create and dispose the cuvit
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final NameCubit cubit;      // defining the cubit in this state

  @override
  void initState() {
    super.initState();
    cubit = NameCubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: ()=>cubit.pickRandomName(),
             child: Text('Pick a random name'),
            );
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return button;
              case ConnectionState.waiting:
                return button;
              case ConnectionState.active:
                return Column(
                  children: [
                    Text(snapshot.data ?? " "),
                    button,
                  ],
                );
              case ConnectionState.done:
                return const SizedBox();
            }
        },
        ),
    );
  }
}
