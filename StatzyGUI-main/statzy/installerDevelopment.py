import os

def question():
    os.system("cls")
    print("========== Statzy instalation tool! ==========")
    print()
    print("1. - You want to install statzy for development?")
    print("2. - You want to install statzy for production?")
    print("3. - You want to update statzy for development?")
    print("4. - You want to update statzy for production?")
    print()
    choice = input("Please enter your choice: ")
    try:
        choice = int(choice)
        if choice > 0 and choice < 5:
            if choice == 1:
                os.system("cls")
                installDevelopment()
            elif choice == 2:
                os.system("cls")
                installProduction()
            elif choice == 3:
                os.system("cls")
                updateDevelopment()
            elif choice == 4:
                os.system("cls")
                updateProduction()
        else:
            print("Please enter a number between 1 and 4!")
            question()
    except:
        print("Please enter a printed number!")
        question()


def installDevelopment():
    print("====== INSTALL DEVELOPMENT ======")


def installProduction():
    print("====== INSTALL PRODUCTION ======")


def updateDevelopment():
    print("====== UPDATE DEVELOPMENT ======")


def updateProduction():
    print("====== UPDATE PRODUCTION ======")


question()