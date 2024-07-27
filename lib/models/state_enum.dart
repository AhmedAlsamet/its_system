
// ignore_for_file: constant_identifier_names

enum States{
  ACTIVE,
  INACTIVE,
  BLOCKED,
  DELETED,
}

// getState(States type){
//     switch (type) {
//       case States.ACTIVE:
//         return "ACTIVE";
//       case States.INACTIVE:
//         return "INACTIVE";
//       case States.BLOCKED:
//         return "BLOCKED";
//       case States.DELETED:
//         return "DELETED";
//       default:
//         return "INACTIVE";
//     }
//   }
//   setState(String type){
//     switch (type) {
//       case "ACTIVE":
//         return States.ACTIVE;
//       case "INACTIVE":
//         return States.INACTIVE;
//       case "BLOCKED":
//         return States.BLOCKED;
//       case "DELETED":
//         return States.DELETED;
//       default:
//         return States.INACTIVE;
//     }
//   }