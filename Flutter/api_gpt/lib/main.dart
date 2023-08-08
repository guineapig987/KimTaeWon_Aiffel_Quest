import 'dart:convert';
import 'package:chatgpt_at_home/role.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat_bot_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final sp = await SharedPreferences.getInstance();
    apiKey = sp.getString(apiKeyId) ?? const String.fromEnvironment(apiKeyId);
  } catch (err, st) {
    debugPrint('failed to retrieve API key: $err');
    debugPrint('Stack trace: $st');
  }

  runApp(const ChatBotApp());
}

Future<SharedPreferences> get sp => SharedPreferences.getInstance();

var apiKey = '';
const apiKeyId = 'openaiApiKey'; // API 키를 저장할 고유 식별자
const material3 = bool.fromEnvironment('material3', defaultValue: true);
const user = 'chatgpt@home'; // 사용자 이름
const done = '[DONE]';

// 요청 헤더를 생성하는 함수
Map<String, String> get requestHeaders =>
    {'content-type': 'application/json', 'authorization': 'Bearer $apiKey'};

// GPT-3 API의 completions 엔드포인트
final completionEndpoint = Uri.https('api.openai.com', '/v1/chat/completions');

// 외부 링크를 열기 위한 함수
void openLinks(String _, String? href, String title) async {
  if (href != null) {
    await launchUrl(
      Uri.parse(href),
      webOnlyWindowName: title,
      mode: LaunchMode.externalApplication,
    );
  }
}

/// GPT-3 API를 통해 채팅을 수행하는 스트림 생성 함수
Stream<String> chat(
  List<ChatMessage> messages, {
  String model = 'gpt-3.5-turbo',
  void Function(dynamic)? onError,
}) async* {
  final request = jsonEncode({
    'model': model,
    'stream': true,
    'user': user,
    'messages': [
      for (final message in messages)
        if (message.role != Role.system)
          {'role': message.role.api, 'content': message.text}
    ]
  });
  final events = await EventSource.connect(
    completionEndpoint,
    method: 'POST',
    headers: requestHeaders,
    body: request,
  ).catchError((error) {
    if (error is EventSourceSubscriptionException) {
      debugPrint('failed to chat: ${error.message}');
    }
    onError?.call(error);

    throw error;
  });

  var role = 'assistant'; // 초기값은 'assistant'
  await for (final event in events) {
    if (event.data == done) break; // 작업이 완료되면 종료

    final data = jsonDecode(event.data!);
    final Map<String, dynamic> delta = data['choices'][0]['delta'];

    if (delta.containsKey('role')) {
      role = delta['role']; // 역할 정보가 변경되면 역할 업데이트
      debugPrint('talking as: $role');
    } else if (delta.containsKey('content')) {
      yield delta['content'] as String; // 내용이 변경되면 yield
    }
  }
}
