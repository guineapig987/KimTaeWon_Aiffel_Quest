import random
from datetime import datetime
class Account:
    Account_count = 0
    def __init__(self, name, balance):
        self.name = name
        self.balance = balance
        self.bank = "SC은행"
        self.account_num = str(random.randint(100,999)) \
        + '-' + str(random.randint(10,99))  \
        + '-' + str(random.randint(100000,999999))  
        self.deposit_count = 0
        self.deposit_history = []
        self.withdraw_history = []
        Account.Account_count += 1 

    @classmethod
    def get_account_num(cls):
        print(cls.Account_count)

    def deposit(self, amount):
        if amount >= 1:
            self.balance += amount
            self.deposit_count += 1
            self.deposit_history.append((amount, datetime.now().strftime("%Y-%m-%d %H:%M:%S"))) # 입금내역 저장

        if self.deposit_count % 5 == 0:
            self.balance = self.balance * 1.01

    def withdraw(self, amount):
        if amount <= self.balance:
            self.balance -= amount
            self.withdraw_history.append((amount, datetime.now().strftime("%Y-%m-%d %H:%M:%S"))) # 출금내역 저장

    def get_deposit_history(self):
        print("입금 내역")
        print(self.deposit_history)


    def get_withdraw_history(self):
        print("출금내역")
        print(self.withdraw_history)

    def display_info(self):
        print("은행이름 : ", self.bank)
        print("예금주 : ", self.name)
        print("계좌번호 : ", self.account_num)
        print("잔고: ", f"{self.balance:,.0f}")
        


newAccount1 = Account("김태원", 4950000)
newAccount2 = Account("기니피그", 3000)
newAccount3 = Account("사슴",43400)
account_list = [newAccount1, newAccount2, newAccount3]


newAccount1.deposit(10000)
newAccount1.deposit(10000)
newAccount1.deposit(10000)
newAccount1.deposit(10000)
newAccount1.deposit(10000)

newAccount1.withdraw(3000)

for account in account_list:
    if account.balance > 1000000:
        account.display_info() 
print('-'*30)
newAccount1.get_deposit_history()
print('-'*30)
newAccount1.get_withdraw_history()