import 'dart:io';

void main(List<String> args) async {
  ServerSocket server = await ServerSocket.bind('localhost', 4567);

  server.listen((client) {
    _handleConnection(client);
  },
  onDone: (){
  });
}

void _handleConnection(Socket client){
  print('Client: ${client.remoteAddress.address}:${client.port}');
  client.listen((event) {
    String data = String.fromCharCodes(event);

    try {
      double nu = num.parse(data).toDouble();
      print(nu);
    } catch (e) {
      print('Solo acepto numeros');
      client.close();
      client.destroy();
    }
  },
  onDone: (){
    client.close();
    client.destroy();
  },
  onError: (e){
    print(e);
    client.close();
  });
}
