```python
import tensorflow as tf
from tensorflow import keras
import numpy as np

#하이퍼파리미터
n_channel_1=32
n_channel_2=64
n_dense=64
n_train_epoch=10

#레이어 생성
model = keras.models.Sequential()
model.add(keras.layers.Conv2D(n_channel_1, (3,3), activation='relu', input_shape=(28,28,3)))
model.add(keras.layers.MaxPooling2D(2,2))
model.add(keras.layers.Conv2D(n_channel_2, (3,3), activation='relu'))
model.add(keras.layers.MaxPooling2D(2,2))
model.add(keras.layers.Flatten())
model.add(keras.layers.Dropout(0.1))    #dropout
model.add(keras.layers.Dense(n_dense, activation='relu'))
model.add(keras.layers.Dense(3,activation='softmax'))

model.summary()


#학습(train 318장, test 300장)
model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
model.fit(x_train, y_train, epochs=n_train_epoch)


#평가 및 시각화
#train데이터와 test데이터 정확도 비교
import matplotlib.pyplot as plt

loss, accuracy = model.evaluate(x_test, y_test)
print("test_loss: {} ".format(loss))
print("test_accuracy: {}".format(accuracy))

history = model.fit(x_train, y_train, epochs=n_train_epoch, validation_data=(x_test, y_test))

plt.figure(figsize=(12, 4))

plt.plot(history.history['accuracy'])
plt.plot(history.history['val_accuracy'])
plt.title('Model accuracy')
plt.ylabel('Accuracy')
plt.xlabel('Epoch')
plt.legend(['Train', 'Test'], loc='upper left')

plt.show()
```



<pre>
Epoch 1/10
10/10 [==============================] - 1s 34ms/step - loss: 35.7339 - accuracy: 0.3270
Epoch 2/10
10/10 [==============================] - 0s 36ms/step - loss: 4.9983 - accuracy: 0.3679
Epoch 3/10
10/10 [==============================] - 0s 38ms/step - loss: 1.3350 - accuracy: 0.5283
Epoch 4/10
10/10 [==============================] - 0s 36ms/step - loss: 0.7124 - accuracy: 0.7013
Epoch 5/10
10/10 [==============================] - 0s 36ms/step - loss: 0.3903 - accuracy: 0.8396
Epoch 6/10
10/10 [==============================] - 0s 39ms/step - loss: 0.1975 - accuracy: 0.9340
Epoch 7/10
10/10 [==============================] - 0s 37ms/step - loss: 0.1306 - accuracy: 0.9717
Epoch 8/10
10/10 [==============================] - 0s 35ms/step - loss: 0.0860 - accuracy: 0.9811
Epoch 9/10
10/10 [==============================] - 0s 36ms/step - loss: 0.0569 - accuracy: 0.9843
Epoch 10/10
10/10 [==============================] - 0s 36ms/step - loss: 0.0239 - accuracy: 0.9969

</pre>

<pre>
10/10 [==============================] - 0s 8ms/step - loss: 7.2212 - accuracy: 0.3333
test_loss: 7.2212233543396 
test_accuracy: 0.3333333432674408
</pre>
<pre>
###과적합 해결 
</pre>
![image](https://github.com/guineapig987/Python_Quest_KimTaeWon/assets/106423212/4d11b441-0b36-4422-a9f4-f1d4aee8b34e)

