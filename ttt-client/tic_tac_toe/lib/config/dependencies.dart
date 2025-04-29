import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:tic_tac_toe/data/socket_service.dart';

List<SingleChildWidget> get providers {
  return [Provider(create: (context) => SocketService())];
}
