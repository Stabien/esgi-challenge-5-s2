import 'package:dio/dio.dart';
import 'package:mobile/mobile/models/message.dart';
import 'package:mobile/web/utils/api_utils.dart';

class MessageServices {
  Future<List<Message>> getMessagesByEvent(String id) async {
    try {
      var response = await ApiUtils.get('/messages/event/$id');

      if (response.statusCode == 200) {
        List<Message> messages = [];

        if (response.data is List) {
          messages = (response.data as List)
              .map((item) => Message.fromJson(item as Map<String, dynamic>))
              .toList();
        }

        return messages;
      } else {
        // print(
        //     'Erreur lors de la récupération des messages: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // print('Erreur inconnue dans getMessagesByEvent: $error');
      return [];
    }
  }

  Future<Response> postMessage(payload) async {
    var data = {
      'date': payload.date,
      'sender': payload.sender,
      'organizerId': payload.organizerId,
      'eventId': payload.eventId,
      'text': payload.text,
    };

    var response = await ApiUtils.post('/messages', data);

    return response;
  }
}
