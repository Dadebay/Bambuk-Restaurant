import 'package:flutter/material.dart';

class SerwisBaha extends StatefulWidget {
  const SerwisBaha({ Key? key }) : super(key: key);

  @override
  _SerwisBahaState createState() => _SerwisBahaState();
}

class _SerwisBahaState extends State<SerwisBaha> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:10,left:20,right: 20),
      child:Row(
            children: [
              Expanded(child: 
              Container(
                  height: 100, 
                  margin: const EdgeInsets.only(right: 10, bottom: 50),
                   decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                   child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(left: 10),child:
                        Image.asset('assets/images/check.png'),
                    ),),
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(left: 10),child:
                        const Text('Thanks a lot !',style: TextStyle(color: Colors.black,fontSize: 10),)
                    ),),
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(right: 10),child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:  const [
                            Text('-Rowshen.art',style: TextStyle(color: Color.fromRGBO(167, 167, 167, 1),fontSize: 10),)
                          ],
                        )
                    ),),
 
                  ],
                ),
                ),
                ),  
              Expanded(child: 
              Container(
                  height: 100, 
                  margin: const EdgeInsets.only( left:10,bottom: 50),
                   decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                      
                    ],
                   
                ),
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(left: 10),child:
                        Image.asset('assets/images/check.png'),
                    ),),
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(left: 10),child:
                        const Text('Siz nirede yereleshyaniz',style: TextStyle(color: Colors.black,fontSize: 10),)
                    ),),
                    Expanded(child:
                    Container(margin:const EdgeInsets.only(right: 10),child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('-Rowshen.art',style: TextStyle(color: Color.fromRGBO(167, 167, 167, 1),fontSize: 10),)
                          ],
                        )
                    ),),
 
                  ],
                ),

                ),  
                ),
                
            ],
        ),
    );
  }
}