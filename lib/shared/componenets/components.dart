import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insurances/shared/cubit/register_cubit/cubit.dart';

Widget defaultButton({
  double width = double.maxFinite,
  Color color = Colors.blue,
  double height = 50,
  IconData icon = Icons.login,
  Color iconColor = Colors.white,
  required String text,
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.bold,
  Color textColor = Colors.white,
  required VoidCallback action,
  bool isUpper = true,
}) => Container(
  width: width,
  color: color,
  height: height,
  child: MaterialButton(
    onPressed: action,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            isUpper ? text.toUpperCase() : text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor,
            ),
          ),
        ],
      ),
    ),
  ),
);

Widget defaultFormField({
  required TextEditingController? controller,
  required String? Function(String?)? validate,
  required TextInputType keyboardType,
  required String labelText,
  IconData prefix = Icons.lock,
  IconData? suffix = null,
  Color prefixIconColor = Colors.grey,
  Color suffixIconColor = Colors.grey,
  Color fillColor = Colors.grey,
  bool obscureText = false,
  String? Function(String)? submit,
  String? Function(String)? change,
  Function()? pressOnIcon,
  Function()? onTap,
  bool isClickable = true,
}) => TextFormField(
  enabled: isClickable,
  onFieldSubmitted: submit,
  onChanged: change,
  validator: validate,
  controller: controller,
  obscureText: obscureText,
  onTap: onTap,
  keyboardType: keyboardType,
  decoration: InputDecoration(
    focusColor: Colors.white,
    prefixIcon: Icon(
      prefix,
      color: prefixIconColor,
    ),
    suffixIcon: suffix !=null ? IconButton(
      onPressed: pressOnIcon,
      icon: Icon(
        suffix,
        color: suffixIconColor,
      ),
    ) : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
      const BorderSide(color: Colors.blue, width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    fillColor: fillColor,
    //make hint text
    hintStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontFamily: "verdana_regular",
      fontWeight: FontWeight.w400,
    ),
    //create lable
    labelText: labelText,
    //lable style
    labelStyle: const TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontFamily: "verdana_regular",
      fontWeight: FontWeight.w400,
    ),
  ),
);
List<String> regionsTunisie = ['Ariana','Beja', 'Ben Arous', 'Bizerte' , 'Gabes' , 'Gafsa' , 'Jendouba' ,
      'Kairouan' , 'Kebili' , 'Kef' , 'Mahdia' , 'Manouba' , 'Medenine' , 'Monastir' , 'Nabeul' , 'Sfax'
  ,'Sidi Bouzid', 'Siliana' , 'Sousse' , 'Tataouine' , 'Tozeur' , 'Tunis' , 'Zaghouan'
] ;
Widget defaultDropDown({
  required context,
  required int elev,
  required List<String> items,
}) => DropdownButton<String>(
  isExpanded: true,
  value: InsurancesRegisterCubit.get(context).value,
  icon: const Icon(Icons.arrow_downward,
  color: Colors.grey,),
  elevation: elev,
  style: const TextStyle(
      color: Colors.blueGrey,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  borderRadius: BorderRadius.circular(10),
  underline: Container(
  height: 2,
  width: 50,
  color: Colors.grey,
),
onChanged: (newValue) => {
    InsurancesRegisterCubit.get(context).changeDropDownValue(
        newValue: newValue
    ),
},
items: items
.map<DropdownMenuItem<String>>((String value) {
return DropdownMenuItem<String>(
value: value,
child: Row(
  children: [
    Icon(Icons.location_city,
    color: Colors.grey,),
        SizedBox(width: 10,),
        Text(value,
        textAlign: TextAlign.center,),
  ],
),
);
}).toList(),
);

Widget buildEmployeeItem(model,context) => Dismissible(
    key: Key(model.uid.toString()),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(
          '${model.fullName}',
        ),
      ),
    ),
);

// Widget buildTaskItem(Map model,context) => Dismissible(
//   key: Key(model['id'].toString()),
//   onDismissed: (direction){
//     TodoCubit.get(context).deleteRecord(id: model['id']);
//     TodoCubit.get(context).getAllTasks(TodoCubit.get(context).database);
//   },
//
//   child:   Padding(
//
//       padding: const EdgeInsets.all(20),
//
//       child: Row(
//
//         children: [
//
//           CircleAvatar(
//
//             radius: 35,
//
//             child: Text(
//
//                 '${model['time']}'
//
//             ),
//
//           ),
//
//           SizedBox(
//
//             width: 20,
//
//           ),
//
//           Expanded(
//
//             child: Column(
//
//               crossAxisAlignment: CrossAxisAlignment.start,
//
//               mainAxisSize: MainAxisSize.min,
//
//               children: [
//
//                 Text(
//
//                   '${model['title']}',
//
//                   style: TextStyle(
//
//                     fontWeight: FontWeight.bold,
//
//                     fontSize: 20,
//
//                   ),
//
//                   maxLines: 1,
//
//                   overflow: TextOverflow.ellipsis,
//
//                 ),
//
//                 SizedBox(
//
//                   height: 5,
//
//                 ),
//
//                 Text(
//
//                   '${model['date']}',
//
//                   style: TextStyle(
//
//                     color: Colors.grey,
//
//                     fontSize: 20,
//
//                   ),
//
//                 ),
//
//
//
//               ],
//
//             ),
//
//           ),
//
//           SizedBox(
//
//             width: 20,
//
//           ),
//
//           Container(
//
//             decoration: BoxDecoration(
//
//               borderRadius: BorderRadius.circular(25),
//
//               color: Colors.green,
//
//             ),
//
//             child: IconButton(
//
//               icon: Icon(
//
//                 Icons.done_outline_rounded,
//
//                 size: 20,
//
//               ),
//
//               onPressed: (){
//
//                 TodoCubit.get(context).updateRecord(
//
//                     status: 'DONE',
//
//                     id: model['id']);
//
//                 TodoCubit.get(context).getAllTasks(TodoCubit.get(context).database);
//
//               },
//
//             ),
//
//           ),
//
//           SizedBox(
//
//             width: 10,
//
//           ),
//
//           Container(
//
//             decoration: BoxDecoration(
//
//               borderRadius: BorderRadius.circular(25),
//
//               color: Colors.amber,
//
//             ),
//
//             child: IconButton(
//
//               icon: Icon(
//
//                 Icons.archive_rounded,
//
//                 size: 30,
//
//               ),
//
//               onPressed: (){
//
//                 TodoCubit.get(context).updateRecord(
//
//                     status: 'ARCHIVED',
//
//                     id: model['id']);
//
//                 TodoCubit.get(context).getAllTasks(TodoCubit.get(context).database);
//
//               },
//
//             ),
//
//           ),
//
//
//
//
//
//         ],
//
//       )
//
//   ),
// );

Widget buildArticleItem(article,context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(article['urlToImage'] == null ? 'https://www.at-languagesolutions.com/en/wp-content/uploads/2016/06/http-1-1024x824.jpg' : article['urlToImage']),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(width: 20,),
      Expanded(
        child: Container(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article['title'],
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Text(
                  article['author'] == null ? 'Couldn\'t load author' : article['author'],
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
);

Widget divider() => Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.blueGrey,
  ),
);

void showToast({
  required String message,
  var length = Toast.LENGTH_SHORT,
  var gravity = ToastGravity.CENTER,
  var TimeForIosWeb = 1,
  var bgColor : Colors.grey,
  var textColor : Colors.white,
  var fontSize : 16.0,
}){
  Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: TimeForIosWeb,
      backgroundColor: bgColor,
      textColor: textColor,
      fontSize: fontSize
  );
}