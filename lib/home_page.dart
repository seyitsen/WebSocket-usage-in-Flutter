import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textEditingController = TextEditingController();
  late WebSocketChannel _channel;
  late Stream _stream;
  
  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('wss://echo.websocket.org'));
    print('Websocket bağlantısı yapıldı...');

    _stream = _channel.stream.asBroadcastStream();
    // Gelen verileri dinle
    _stream.listen(
          (data) {
        print('Gelen mesaj: $data');
      },
      onError: (error) {
        print('WebSocket Hatası: $error');
      },
      onDone: () {
        print('WebSocket bağlantısı kapatıldı.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  void _sendMessage() {
    if(_textEditingController.text.isNotEmpty){
      print('Gönderilen mesaj: ${_textEditingController.text}');
      _channel.sink.add(_textEditingController.text);
    }
  }

  @override
  void dispose(){
    print('Websocket bağlantısı kapatılıyor...');
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.brown,
      title: Center(
        child: Text(
          "Websocket Usage",style: TextStyle(color: Colors.white,fontSize: 24,
            fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: 'Mesajınızı giriniz',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.brown),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.brown, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.brown),
              ),
            ),
          )
          ,
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: _stream,
                builder: (context, message) {
                  if (message.hasData && message.data != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        message.data.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text('Bekleniyor...'),
                    );
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: _sendMessage,

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
            ),
            child: Text('Mesaj Gönder',style: TextStyle(color: Colors.white,fontSize: 24),),
          ),

        ],
      ),
    );
  }

}
