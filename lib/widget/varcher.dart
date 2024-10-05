import 'package:flutter/material.dart';

class Cherche extends StatelessWidget{
  const Cherche({super.key});

  @override
  Widget build(BuildContext){
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: const Stack(
        children: [
          TextField(
            decoration: InputDecoration(fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3,
                        style: BorderStyle.none
                    )
                ),
                prefixIcon: Icon(Icons.search_outlined,
                  weight: 10,
                )
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child:
            SizedBox(
              height: 10,
              width: 10,
              //color: Colors.deepOrange,

            ),
          )
        ],
      ),
    );
  }
}