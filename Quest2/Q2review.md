# Code Peer Review Templete

- 코더 : 김태원
- 리뷰어 : 백기웅

---

# PRT(PeerReviewTemplate)

각 항목을 스스로 확인하고 체크하고 확인하여 작성한 코드에 적용하세요.

- [ ] 코드가 정상적으로 동작하고 주어진 문제를 해결했나요?
- [*] 주석을 보고 작성자의 코드가 이해되었나요?
- [ ] 코드가 에러를 유발할 가능성이 있나요?
- [*] 코드 작성자가 코드를 제대로 이해하고 작성했나요? (직접 인터뷰해보기)
- [*] 코드가 간결한가요?

---
작성한 코드
<pre>
<code>
!pip install ColabTurtlePlus


from ColabTurtlePlus.Turtle import *
import pprint


maze = [
    [0, 1, 0, 0, 0],
    [0, 0, 0, 1, 0],
    [0, 1, 1, 0, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 0, 0]
]

t = Turtle()

# t.shape("turtle")
# t.shapesize(3,4,2)


for x in range(5):  # maze 좌표 탐색
  for y in range(5):  
    if maze[x][y] ==1:
      print("벽을 만났습니다.")
      break # 벽을 만나면 다음 행 탐색
      
    else:
      t.goto(x,y) # 길로 이동
      maze[x][y] = 2  # 찾은 길 2로 저장
      print("길을 찾았습니다")  
print("현재 좌표 : ",t.position()) 

pprint.pprint(maze)
</code>
</pre>

# 참고 링크 및 코드 개선 여부

1. 전반적으로 이해하기 쉽고 간결하게 작성 했다고 생각합니다.
2. 그러나 실제 나온 결과값으로는 quest의 목적을 달성할 수 없었습니다.
3. 저도 해결하지 못해서 개선 여부를 판단할 수 없을 것 같습니다. 




















