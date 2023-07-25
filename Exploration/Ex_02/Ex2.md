# Code Peer Review Templete

- 코더 : 김태원
- 리뷰어 : 백기웅

---

# PRT(PeerReviewTemplate)

각 항목을 스스로 확인하고 체크하고 확인하여 작성한 코드에 적용하세요.

- [_] 코드가 정상적으로 동작하고 주어진 문제를 해결했나요?
- [o] 주석을 보고 작성자의 코드가 이해되었나요?
- [_] 코드가 에러를 유발할 가능성이 있나요?
- [o] 코드 작성자가 코드를 제대로 이해하고 작성했나요?
- [o] 코드가 간결한가요?

---

1. 독창적으로 모델을 생성하고 오류없이 빌드 되었습니다.
```
# 모델 생성
model = Model([encoder_inputs, decoder_inputs], decoder_outputs)

# 모델 컴파일 및 학습
model.compile(optimizer='rmsprop', loss='sparse_categorical_crossentropy')
es = EarlyStopping(monitor='loss', mode='min', verbose=1, patience=2)
model.fit([x_train, y_train[:, :-1]], y_train[:, 1:], epochs=50, callbacks=[es], batch_size=64)
```
2. 검증데이터를 설정하여 학습 되었다면 좋았을 것 같습니다.

---

   - Code 에 대한 리뷰어의 Comment 를 남겨주세요

코드 잘 봤습니다. 수고하셨습니다~
