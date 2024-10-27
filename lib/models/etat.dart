// Ce file contient le code de l'etat de l'app global avec riverpod il ne pas
// fonctionnable car l'app est lancer  avec un fournisseur de tâches Provider avec la méthode
//ChangeNotifierProvider() dans la fonction principale et si je le change avec ProviderScope()
//pour gèrer l'etat global de l'app mon code sera impacter

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//class CounterNotifier extends StateNotifier<int> {
  //CounterNotifier()
     // : super(0);
  //void increment() {
 // state++;
//  }
//}
//final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
 // return CounterNotifier();
//});

class Etat extends ConsumerWidget {
  const Etat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final count = ref.watch(counterProvider);
    return Scaffold(
        appBar:  AppBar(
          title: Text('DOSTA'),
        )
    );


//return Column(

  //children: [
//Text('You have pushed the button this many times:'),
//Text(
//'$count',
 // style: Theme.of(context).textTheme.headlineMedium,
//),
    //ElevatedButton(
   // onPressed:
   // () {
   // ref.read(counterProvider.notifier).increment();
    //},
    //child: const
   // Text('Increment'),
    //),
   // ],

//);


  }

  }


