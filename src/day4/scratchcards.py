def main():
    with open("cards.txt", "r") as f:
        data = f.read()
        sum_ = 0
        card_copy = {}
        proceed_card = 0
        for card_number, card in enumerate(data.split("\n")):
            print("card is : ", card_number+1)
            card_copy[f"card_{card_number + 1}"] = card_copy.get(f"card_{card_number + 1}", 0) + 1
            while card_copy.get(f"card_{card_number + 1}", 0) != 0:
                proceed_card += 1
                card_score = 0
                number_of_number = 0
                winning = [e for e in card.split(":")[1].split("|")[0].split(" ")]
                my_number = [e for e in card.split(":")[1].split("|")[1].split(" ")]
                for e in my_number:
                    if e.isdigit() and e in winning:
                        if card_score == 0:
                            card_score = 1
                        else:
                            card_score = card_score * 2
                        number_of_number += 1
                sum_ += card_score
                #print("card_score is: ", card_score)
                #print("number of card is : ", number_of_number)
                for i in range(number_of_number):
                    card_copy[f"card_{card_number + 2 + i}"] = card_copy.get(f"card_{card_number + 2 + i}", 0) + 1
                #print("card_copy is : ", card_copy)
                card_copy[f"card_{card_number + 1}"] -= 1
            print("total sum is : ", sum_)
            print("card_proceed is : ", proceed_card)


if __name__ == "__main__":
    main()