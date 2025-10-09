import 'dart:io';

void main() async {
  // Kết nối tới server WebSocket (ví dụ server echo test của Dart)

  ///hello cả nhà
  var socket = await WebSocket.connect('wss://bsocket.event');

  // Lắng nghe tin nhắn (single-subscription stream)
  socket.listen((message) {
    // print("Listener 1 nhận: $message");
  });

  // Nếu thêm một listener nữa sẽ bị lỗi:
  // Bad state: Stream has already been listened to.
  socket.listen((message) {
    // print("Listener 2 nhận: $message");
  });

  // Gửi tin nhắn
  socket.add("Xin chào server!");
}
