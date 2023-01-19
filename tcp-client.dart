import 'dart:io';

void main(List<String> args) async {
  String host = 'localhost';
  int port = 4567;
  if(args.length < 1 || args.length > 4) {
    print('SE ESPERA: [-h HOSTNAME -p PORT]');
    return;
  }  
  host = args[1];
  try {
    port = num.parse(args[3]).toInt();
  } catch(e) {
    print('INCORRECT PORT');
    exit(0);
  }

  try {
    
    Socket socket = await Socket.connect(host, port);
    String cli = '${socket.remoteAddress.address}:${socket.port}';
    print('CONNECTED: $cli');

    socket.listen((event) {
      print(String.fromCharCodes(event));
    },
    onDone: (){
      print('DISCONNECT');
      socket.destroy();
    },
    onError: (e){
      print('SERVER NOT FOUND');
      socket.destroy();
    });

    int count = 0;
    while(count < 20){
      String? data = stdin.readLineSync();
      if(data == null) {
        socket.close();
        break;
      }
      if(data == 'exit') {
        socket.close();
        break;
      }

      try {
        double nu = num.parse(data).toDouble();
        socket.write(nu);
        count++;
      } catch (e) {
        print('ONLY NUMBERS');
        socket.close();
        socket.destroy();
        break;
      }
    }
  } catch (e) {
    if(e is SocketException) print('UNKNOWN TCP SERVER');
    else print(e);
  }
}
