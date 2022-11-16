import 'dart:async';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riceking/notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
  designSize: Size(412, 732),
  builder: (() =>  MaterialApp(
      title: "Rice King",
      home: Splash(),
      debugShowCheckedModeBanner: false,
    ))
);
  }
}




class Home extends StatefulWidget {
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownValue = 'Basmati Rice';
  int count = 999;
  Timer? timer;
  bool tog = true;
  bool tog2 = false;
  TextEditingController cups = new TextEditingController();
  TextEditingController type = new TextEditingController();
  double amt = 0;
  double water = 0;
  int time = 0;
  bool changed = false;
  String message = " ";
  int spectime = 0;
  int scanned = 0;


  startscan () {
    if (scanned == 0) {
      message = "Ive scanned your rice. Make sure to keep me open in the background of your phone while cooking! Scan for updates!";
    } else if (count > (time * 5/6)) {
      message = "You can't fool me. You obviously just started. Wait";
    } else if ((count > (time * 4/6)) && (count < (time * 5/6))) {
      message = "A little impatient buddy. Go relax. Still cooking";
    } else if ((count > (time * 3/6)) && (count < (time * 4/6))) {
      message = "Looks almost half way there. Hang in there tiger";
    } else if ((count > (time * 2/6)) && (count < (time * 3/6))) {
      message = "Seems to be over half way. The hardest part is over. You're over the hill now";
    } else if ((count > (time * 1/6)) && (count < (time * 2/6))) {
      message = "Getting closer. Should only be a few more minutes";
    } else if ((count < (time * 1/6)) && count > 0) {
      message = "Almost done. Stay close to your rice cooker";
    } else if (count == 0){
    message = "Your rice is done. Take it out as you please. Enjoy!";}
  }

  starttimer() {
    count = time;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count > 0) {
        setState(() {
          count--;
          print(count);
        });
         if (count == time/2){
      NotificationService().showNotification(1, "RiceBot:", "Use those brains and check on those grains!");
        }
      } else if (count == 0) {
        timer.cancel();
        NotificationService().showNotification(2, "RiceBot:", "Your rice is finished! Enjoy!");
      } else if (count == -999) {
        timer.cancel();
      }
    });
  }

calculatetime() {
    
    print(cups.text);

    if (dropdownValue == "White Long Grain Rice")
    {
      amt =  double.parse(cups.text) / 2;
      water = int.parse(cups.text) * 2;
      time = 1140;
    }
    else if (dropdownValue == "White Medium Grain Rice")
    {
      amt =  double.parse(cups.text) / 2;
      water = double.parse(cups.text) * 1.5;
      time = 900;
    }
    else if (dropdownValue == "White Short Grain Rice")
    {
      amt =  double.parse(cups.text) / 3;
      water = int.parse(cups.text) * 1.25;
      time = 900;
    }
    else if (dropdownValue == "Brown Long Grain Rice")
    {
      amt =  double.parse(cups.text) / 2.5;
      water = int.parse(cups.text) * 1.75;
      time = 2520;
    }
    else if (dropdownValue == "Brown Medium Grain Rice")
    {
      amt =  double.parse(cups.text) / 3;
      water = int.parse(cups.text) * 2;
      time = 3000;
    }
    else if (dropdownValue == "Brown Short Grain Rice")
    {
     amt =  double.parse(cups.text) / 3;
      water = int.parse(cups.text) * 2;
      time = 3000;
    }
    else if (dropdownValue == "Jasmine Rice")
    {
      amt =  double.parse(cups.text) / 3;
      water = int.parse(cups.text) * 1.75;
      time = 1020;
    }
    else if (dropdownValue == "Basmati Rice")
    {
     amt =  double.parse(cups.text) / 3;
      water = int.parse(cups.text) * 1.5;
      time = 1020;
    }
    else if (dropdownValue == "Wild Rice")
    {
      amt =  double.parse(cups.text) / 2.5;
      water = int.parse(cups.text) * 2;
      time = 2900;
    }
     else if (dropdownValue == "Sushi Rice")
    {
     amt =  double.parse(cups.text) / 2.5;
      water = int.parse(cups.text) * 1.33;
      time = 1200;
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      backgroundColor: Colors.white,
      
      body: Center(
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(height: 20.h, width: 340.w,
            alignment: Alignment.centerRight,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Mode: ", style: TextStyle(fontSize: 15.sp, color: Colors.black),), (scanned == 0)? Image.asset('assets/images/pm.png', height: 30, width: 30,) : Image.asset('assets/images/cm.png', height: 30, width: 30,)])),
            Image.asset('assets/images/splash3.png', height: 100.h, width: 200.w),
            SizedBox(height: 20.h),
            SizedBox(
              height: 50.h,
              width: 300.w,
              child:  DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 1.25.h,
        color: Colors.black,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Basmati Rice', 'Brown Long Grain Rice', 'Brown Medium Grain Rice', 'Brown Short Grain Rice' , 'Jasmine Rice', 'Sushi Rice', 'White Long Grain Rice', 'White Medium Grain Rice', 'White Short Grain Rice', 'Wild Rice']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          
          value: value,
          child: Text(value, style: TextStyle(fontSize: 15.sp, color: Colors.black),),
        );
      }).toList(),
    ),
    ),
    SizedBox(height: 25.h,),
        SizedBox(width:300.w,
        height: 30.h,
        child:   TextFormField(
                     
                      style: TextStyle(color: Colors.black,
                      fontSize: 15.sp),
                      cursorColor: Colors.black,
                      controller: cups,
                      decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        
                        borderSide: BorderSide(
                          color: Colors.black, width: 1.15.w
                      ),),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1.15.w)),
                      hintText: "Desired Cups of Rice"),
              
            )
            ),

            SizedBox(
              height: 25.h,
            ),
            SizedBox(width: 225.w, height: 35.h, child: ElevatedButton(
              style: ElevatedButton.styleFrom(
            primary: Colors.black, // Background color
            ),
              onPressed: () {
                if (cups.text != ""){
              calculatetime();
              setState(() {
                changed = true;
              });
                }
            
            }, child: Text("Cooking Instructions", style: TextStyle(fontSize: 13.sp, color: Colors.white)))),

            SizedBox(height: 10.h),

            (changed == true)
             ? SizedBox(width: 300.w,
              child: Container(
          width: 300.0.w,
          height: 50.0.h,
          decoration: BoxDecoration(
            border: Border.all(width: 3.w, color: Colors.black),
            color: Colors.white,
          ),
          child: Center(
            child: Text(
             "Please add " + double.parse((water).toStringAsFixed(2)).toString() + " cups of water" + "\n" + "Please add " + double.parse((amt).toStringAsFixed(2)).toString() + " cups of rice",
              style: TextStyle(fontSize: 17.sp, color: Colors.black)
            ),
          ),
        ),
              )
              : SizedBox(width: 200.w,
              child: Container(
          width: 300.0.w,
          height: 50.0.h)),
          SizedBox(height: 5.h),
          SizedBox(height: 20.h,
          child: (scanned == 0 )? Text(""):Text("Press to re-enter Prep Mode", style: TextStyle(fontSize: 15.sp, color: Colors.black))),
            
          

            
        SizedBox(height: 45.h, width: 100.w,
         child: MaterialButton(
                height: 30.h,
                color: Colors.black,
                splashColor: Colors.white,
                onPressed: () {
                   setState(() {
                 cups.clear();
                 count = -999;
                 changed = false;
                 spectime = 0;
                 scanned = 0;
                 message = " ";
                 });
                },
                child: Icon(Icons.restart_alt_rounded,
                color: Colors.white,
                size: 40.h)
              )),
          
            SizedBox(height: 3.h,),

            SizedBox(height: 20.h,
            child: (scanned == 0)? Text("Scan to enter Cooking Mode", style: TextStyle(fontSize: 15.sp, color: Colors.black)) : Text(" ")),


           SizedBox(height: 45.h, width: 100.w,
          child: MaterialButton(
          height: 30.h,
                color: Colors.black,
                splashColor: Colors.white,
                onPressed: () async {
                  if (scanned == 0){
                   if (cups.text != ""){
                  type.text=dropdownValue;
                  calculatetime();
                  starttimer();
                 }}
                  
                  if( scanned > 0) {
                  spectime = time - (time - count);
                   if (count == 0){
                    setState(() {
                      spectime = -1;
                    });
                    
                  }}
                  
                  startscan();
                 // WidgetsFlutterBinding.ensureInitialized();
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;
                  if (cups.text != "") {
                  Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => TakePictureScreen(camera: firstCamera, message: message,)));
                scanned++;
                }
                else{
                  final snackBar = SnackBar(
                  content: const Text('Please enter your desired yield of rice.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                
                },
                child: Image.asset('assets/images/scanbutton.png',
                height: 40.h,
                width: 40.w)
              )),
            
            
            SizedBox(height: 20.h),

            (spectime != 0) 
            ?SizedBox(
            height: 20.h, child: Container(alignment: Alignment.center, width: 200.w, child:
            LinearPercentIndicator(
            width: 200.w,
            lineHeight: 12.0.h,
            animation: false,
            percent: (spectime != -1)? (1 - spectime/time) : 1,
          backgroundColor: Colors.grey,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.black,
          )))
          : SizedBox(height: 20.h),

          SizedBox(height: 20.h),

            (count ==0 && spectime != -1)
            ?Text("Update: Scan Rice!", style: TextStyle(fontSize: 20.sp, color: Colors.black))
            :Text(""),

            
          ],
        ),
      ),
    );

  }
}

class Splash  extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _nameState();
}

class _nameState extends State<Splash> {
  int count = 3;
  Timer? timer;
  bool tog = true;

  starttimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count > 0) {
        setState(() {
          count--;
        });
      } else {
        timer.cancel();
        Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    starttimer();

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
        child: Column(children: [
          SizedBox(height: 200.h),
          Image.asset("assets/images/splash1.png"),
          SizedBox(height: 30.h),
          Text("Rice. Made Simple.", style: TextStyle(fontSize: 25.sp, color: Colors.black, fontStyle: FontStyle.italic, decoration: TextDecoration.none)),
          
          
        ])
    );
    
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
    required this.message
  });

  final CameraDescription camera;
  final String message;
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool picture = false;
  

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      leading: Image.asset('assets/images/picicon.png',
      scale: 2.9,),
      title: const Text('Scan Your Rice'),
      actions: [Image.asset('assets/images/picicon.png',
      scale: 2.9,)],
      centerTitle: true,
      backgroundColor: Colors.black),
      
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller, 
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()  {
           Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => mesScreen(message: widget.message,)));
        },
        child: const Icon(Icons.camera_alt,
        color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}

class mesScreen extends StatefulWidget {
  mesScreen({Key? key, required this.message}) : super(key: key);

final String message;
  @override
  State<mesScreen> createState() => _mesScreenState();
}

class _mesScreenState extends State<mesScreen> {
  @override
  int count = 3;
  Timer? timer;
  double height = 130;
  bool prog = false;

  starttimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count > 0) {
        setState(() {
          count--;
        });
      } else {
        timer.cancel();
        setState(() {
          prog = true;
          height = 30;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    starttimer();

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
        child: Column(children: [
          SizedBox(height: 50.h),

          Image.asset("assets/images/splash1.png"),

         SizedBox(height: height.h),

          (prog == false)
          ? SizedBox(height: 250.h,
            child: RefreshProgressIndicator(
            color: Colors.white, 
            backgroundColor: Colors.black))
          : SizedBox(width: 350.w, height: 350.h,
              child: Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
            alignment: Alignment.topLeft,
          width: 250.0.w,
          height: 350.0.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 5.w),
            color: Colors.white,
          ),
          child: Center(
            child: Text("RiceBot: \n \n \n \n" + widget.message,
            textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.sp, color: Colors.black, decoration: TextDecoration.none))
            ),
          ),
        ),
              
          SizedBox(height:20.h),

          SizedBox(height: 40.h, width: 60.w, child: ElevatedButton(onPressed: () {
           Navigator.pop(context);
           Navigator.pop(context);
          }, 
            style: ElevatedButton.styleFrom(
            primary: Colors.black, // Background color
            ),
          child: Icon(Icons.arrow_back, color: Colors.white,)))
        ],)
       
    );
    
  }
}
