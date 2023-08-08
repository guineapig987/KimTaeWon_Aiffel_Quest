import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Modulabs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final CameraController _cameraController; // 카메라 컨트롤러 인스턴스 선언
  final _controller = TextEditingController(); // 텍스트 입력 컨트롤러 인스턴스 선언
  TranslateLanguage _sourceLanguage = TranslateLanguage.english; // 번역 원본 언어
  TranslateLanguage _targetLanguage = TranslateLanguage.korean; // 번역 대상 언어
  late OnDeviceTranslator _onDeviceTranslator =
      _onDeviceTranslator = OnDeviceTranslator(
    sourceLanguage: _sourceLanguage,
    targetLanguage: _targetLanguage,
  ); // onDevice 번역기 인스턴스 선언

  final _translationController =
      StreamController<String>(); // 번역 결과를 제어하는 스트림 컨트롤러
  bool _cameraIsBusy = false; // 카메라 작업 중 여부
  bool _recognitionIsBusy = false; // 텍스트 인식 작업 중 여부
  late final stt.SpeechToText _speechToText; // 음성 인식 인스턴스
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin); // 텍스트 인식 인스턴스 생성
  bool _canProcess = true; // 텍스트 처리 가능 여부
  bool _isBusy = false; // 작업 중 여부
  String? _text; // 텍스트 인식 결과
  final ImagePicker _picker = ImagePicker(); // 이미지 선택 인스턴스

  @override
  void dispose() {
    _translationController.close(); // 번역 결과 스트림 컨트롤러 닫기
    _onDeviceTranslator.close(); // 온-디바이스 번역기 닫기
    _textRecognizer.close(); // 텍스트 인식기 닫기
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // 카메라 초기화 메서드 호출
    _initializeSpeechToText(); // 음성 인식 초기화 메서드 호출
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.medium,
    ); // 카메라 컨트롤러 초기화

    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }); // 카메라 초기화 및 화면 업데이트
  }

  Future<void> captureAndRecognizeText() async {
    if (_recognitionIsBusy) return; // 이미 인식 작업 중인 경우 중단
    _recognitionIsBusy = true;

    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera); // 카메라로부터 이미지 캡처
    if (image != null) {
      _recognizeText(InputImage.fromFilePath(image.path)); // 이미지에서 텍스트 인식
    }

    _recognitionIsBusy = false;
  }

  Future<void> _recognizeText(InputImage inputImage) async {
    _recognitionIsBusy = true;

    final recognizedText =
        await _textRecognizer.processImage(inputImage); // 이미지에서 텍스트 인식 수행
    _controller.text = recognizedText.text; // 텍스트 입력 컨트롤러에 인식된 텍스트 할당

    _recognitionIsBusy = false;
  }

  Future<void> _initializeSpeechToText() async {
    _speechToText = stt.SpeechToText();
    await _speechToText.initialize(); // 음성 인식 초기화
  }

  void startListening() {
    _speechToText.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords; // 인식된 음성을 텍스트 입력 컨트롤러에 할당
        });
      },
    );
  }

  void stopListening() {
    _speechToText.stop(); // 음성 인식 중지
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 45.0,
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: DropdownButtonFormField<TranslateLanguage>(
                      value: _sourceLanguage,
                      onChanged: (value) {
                        setState(() {
                          _sourceLanguage = value!;
                          _onDeviceTranslator = OnDeviceTranslator(
                            sourceLanguage: _sourceLanguage,
                            targetLanguage: _targetLanguage,
                          );
                          print(_sourceLanguage);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: TranslateLanguage.english,
                          child: Text('영어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.korean,
                          child: Text('한국어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.japanese,
                          child: Text('일본어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.chinese,
                          child: Text('중국어'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: '소스 언어',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: DropdownButtonFormField<TranslateLanguage>(
                      value: _targetLanguage,
                      onChanged: (value) {
                        setState(() {
                          _targetLanguage = value!;
                          _onDeviceTranslator = OnDeviceTranslator(
                            sourceLanguage: _sourceLanguage,
                            targetLanguage: _targetLanguage,
                          );
                          print(_targetLanguage);
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: TranslateLanguage.english,
                          child: Text('영어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.korean,
                          child: Text('한국어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.japanese,
                          child: Text('일본어'),
                        ),
                        DropdownMenuItem(
                          value: TranslateLanguage.chinese,
                          child: Text('중국어'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: '타겟 언어',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: '번역할 내용을 입력하세요',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (text) async {
                final translation =
                    await _onDeviceTranslator.translateText(text);
                _translationController.add(translation);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<String>(
              stream: _translationController.stream,
              builder: (context, snapshot) {
                return Center(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.data ?? '',
                      style: const TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              captureAndRecognizeText();
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: Colors.yellow,
              child: const Icon(Icons.search),
            ),
          ),
          InkWell(
            onTap: () {
              if (_speechToText.isListening) {
                stopListening();
              } else {
                startListening();
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 75,
              color: Colors.orange,
              child: const Icon(Icons.mic),
            ),
          ),
        ],
      ),
    );
  }
}
