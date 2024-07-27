import 'package:rive/rive.dart';

class RiveUtils {
  static SMIBool getRiveInput(Artboard artboard,
      {required String stateMachineName}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);

    artboard.addController(controller!);
    return controller.findInput<bool>("active") as SMIBool;
  }

  static Future<void> chnageSMIBoolState(SMIBool input,SMIBool? lastInput,int index) async{
    if(lastInput!=null) {
      lastInput.change(false);
    }
    input.change(true);
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        // if(index == 2){

        // }else{
          input.change(false);
        // }
      },
    );
  }
}
