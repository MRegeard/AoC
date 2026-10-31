def main():
    with open("../../input/day1/calib.txt", "r") as f:
        text = f.read()
        sum_ = get_sum(text)
    print(f"First sum is {sum_}")
    sum_ = get_sum_letters(text)
    print(f"Second sum is {sum_}")


def get_sum(text):
    sum_ = 0
    for line in text.split("\n"):
        chars = list(line)
        numbers = [int(char) for char in chars if char.isdigit()]
        if len(numbers) >= 1:
            sum_ += numbers[0] * 10 + numbers[-1]
    return sum_


def get_sum_letters(text):
    lookup = {"one": 1,
                "two": 2,
                "three": 3,
                "four": 4,
                "five": 5,
                "six": 6,
                "seven": 7,
                "eight": 8,
                "nine": 9,
                "1": 1,
                "2": 2,
                "3": 3,
                "4": 4,
                "5": 5,
                "6": 6,
                "7": 7,
                "8": 8,
                "9": 9
                }
    sum_ = 0
    for line in text.split("\n"):
        print(line)
        found = []
        for s in lookup.keys():
            if s in line:
                found.append(s)
        print(found)
        if len(found) == 0:
            continue
        else:
            sort_list = [s for _, s in sorted(zip([line.index(s) for s in found], found))]
            rsort_list = [s for _, s in sorted(zip([line.rindex(s) for s in found], found))]
            print(sort_list)
            print(rsort_list)
            sum_ += lookup[sort_list[0]] * 10 + lookup[rsort_list[-1]]
    return sum_


if __name__ == "__main__":
    main()
