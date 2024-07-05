import 'package:mobile/services/api_event_services.dart';
import 'package:mobile/models/event.dart';
import 'package:mobile/services/formatDate.dart';
import 'package:flutter/material.dart';
import 'package:mobile/components/expandable_fab.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class EventsOrganizer extends StatefulWidget {
  const EventsOrganizer({super.key});

  @override
  State<EventsOrganizer> createState() => _EventsOrganizerState();
}

class _EventsOrganizerState extends State<EventsOrganizer> {
  late List<Event> _events = [];
  bool _loading = false;
  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  void _fetchEvents() async {
    setState(() {
      _loading = true;
    });

    ApiServices.getEventsOrganizer().then((data) {
      setState(() {
        _loading = false;
        _events = data;
      });
    });
  }

  void _connectWebSocket() {
    setState(() {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://10.0.2.2:3000/ws'),
      );
      print('essaye au serveur WebSocket');

      _channel!.sink.add('Bonjour serveur, je suis connecté!');

      _channel!.stream.listen((message) {
        print('Message reçu: $message');
      });
    });
  }

  void _sendMessage(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  @override
  void dispose() {
    _channel?.sink.close(status.goingAway);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evénements organisateur'),
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () async {
              final result =
                  await Navigator.of(context).pushNamed('/event/create');
              if (result == true) {
                _fetchEvents();
              }
            },
            icon: const Icon(Icons.add_box_outlined),
          ),
          ActionButton(
            onPressed: () => Navigator.of(context).pushNamed('/event/join'),
            icon: const Icon(Icons.person_add_alt_rounded),
          ),
          ActionButton(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Scanner un QR code"),
                content: const Text("Veuillez scanner le QR code."),
                actions: <Widget>[
                  TextButton(
                    child: const Text("Annuler"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: const Text("Scanner"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final event = _events[index];
                          return GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              '/event/detail',
                              arguments: event.id,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image(image: NetworkImage(event.image)),
                                  Text(
                                    event.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    event.place,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    transformerDate(event.date),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                      ), // Bordure blanche fine
                                      borderRadius: BorderRadius.circular(
                                          8), // Bordures arrondies
                                    ),
                                    child: Text(
                                      event.tag,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          final result =
                                              await Navigator.of(context)
                                                  .pushNamed(
                                            '/event/update',
                                            arguments: event.id,
                                          );
                                          if (result == true) {
                                            _fetchEvents();
                                          }
                                        },
                                        child: const Text('Modifier'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Supprimer"),
                                            content: const Text(
                                                "Voulez-vous vraiment supprimer cet événement ?"),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text("Annuler"),
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                              ),
                                              TextButton(
                                                child: const Text("Supprimer"),
                                                onPressed: () {
                                                  ApiServices.deleteEvent(
                                                          event.id)
                                                      .then((_) {
                                                    Navigator.of(context).pop();
                                                    _fetchEvents();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        child: const Text('Supprimer'),
                                      ),
                                      ElevatedButton(
                                        onPressed: _connectWebSocket,
                                        child: const Text('Chat'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: _events.length,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
