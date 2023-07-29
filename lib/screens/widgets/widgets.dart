import 'package:flutter/material.dart';
import '../widgets/styles.dart';


 
class friendCard extends StatelessWidget {
   friendCard({required this.name,required this.lastMessage,required this.lastHour});
  String name;
  String lastMessage;
  String lastHour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          color: pink,
          height: 70,
         
          child: Row(
            children: [
              SizedBox(width: 5,),
              CircleAvatar(
                  backgroundImage: AssetImage('images/avatar.png'),),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(name),
                       Text(lastMessage),
                    ]
                  ),
                 SizedBox(width: 60,),
                      
                  Text(lastHour),
                  ])
            
          ),
      ),
      );
    
  }
}
