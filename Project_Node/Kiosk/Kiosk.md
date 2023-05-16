# 문제 3-3. 클래스 업데이트  
```python

class Kiosk:
    menu = ['americano', 'latte', 'mocha', 'yuza_tea', 'green_tea', 'choco_latte']
    price = [2000, 3000, 3000, 2500, 2500, 3000]      
    def __init__(self):
        self.ordered_menu =  []
        self.ordered_price =  []
        self.price_sum = 0
    # 메뉴 출력 메서드
    def menu_print(self):
        for index, (menu,price) in enumerate(zip(self.menu, self.price)):
            print(f"{index+1}. {menu}  : , {price}원")

    # 온도 선택 메서드
    def temperature_select(self):
        t = int(input("온도를 선택해주세요.\n 1.Ice\n 2.Hot\n"))
        if t == 1:
            self.temp = 'Ice'           
        elif t == 2:
            self.temp = 'Hot'
        else:
            print("(온도선택)올바른 입력이 아닙니다.")
            return self.temperature_select()   # 재입력을 위해 재귀 호출

    # # 주문 메서드
    def menu_select(self):
        n = int(input("주문하실 메뉴번호를 입력해주세요 (주문하기 0번) : "))
        if 0 < n <= len(self.menu):
            self.temperature_select()

            self.ordered_menu.append(self.temp + ' ' + self.menu[n-1]) # 주문목록 추가
            self.ordered_price.append(self.price[n-1])

            print(f"선택 메뉴 >> {self.temp + ' ' + menu[n-1]} : {price[n-1]}")

            self.menu_select() # 추가주문을 위해 재귀 호출

        elif n == 0:
            return  # 주문종료 후 pay 단계로 이동
        else:
            print("(메뉴선택)올바른 입력이 아닙니다.")              
            return self.menu_select()   # 재입력을 위해 재귀 호출
            
      
    # # 지불
    def pay(self):   
        print("결제수단을 선택해주세요.")
        print("1.카드")
        print("2.현금")
        n = int(input(""))
        if n == 1:
            print("카드를 넣어주세요.")
        elif n == 2:
            print("직원에게 계산해주세요.")
        else:
            print("올바른 입력이 아닙니다.")
            return self.pay()


    # # 주문서 출력 
    def table(self):
        self.price_sum = sum(self.ordered_price) 
        print("선택 목록")
        print('-'*30)
        for menu, price in zip(self.ordered_menu,self.ordered_price):
            print(f"{menu} : {price}")
        print(f"결제하실 금액 : {self.price_sum}")
        print('-'*30)
        
a = Kiosk()  # 객체 생성 
a.menu_print()  # 메뉴 출력
a.menu_select()  # 주문
a.pay()  # 지불
a.table()  # 주문표 출력
```
#
```
1. americano  : , 2000원
2. latte  : , 3000원
3. mocha  : , 3000원
4. yuza_tea  : , 2500원
5. green_tea  : , 2500원
6. choco_latte  : , 3000원
주문하실 메뉴번호를 입력해주세요 :  3
온도를 선택해주세요.
 1.Ice
 2.Hot
 1
선택 메뉴 >> Ice mocha : 3000
주문하실 메뉴번호를 입력해주세요 :  8
(메뉴선택)올바른 입력이 아닙니다.
주문하실 메뉴번호를 입력해주세요 :  4
온도를 선택해주세요.
 1.Ice
 2.Hot
 7
(온도선택)올바른 입력이 아닙니다.
온도를 선택해주세요.
 1.Ice
 2.Hot
 2
선택 메뉴 >> Hot yuza_tea : 2500
주문하실 메뉴번호를 입력해주세요 :  0
결제수단을 선택해주세요.
1.카드
2.현금
 4
올바른 입력이 아닙니다.
결제수단을 선택해주세요.
1.카드
2.현금
 1
카드를 넣어주세요.
선택 목록
------------------------------
Ice mocha : 3000
Hot yuza_tea : 2500
결제하실 금액 : 5500
------------------------------

```
