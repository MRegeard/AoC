def main_1():
    sum_ = 0
    with open('gear.txt', 'r') as f:
        data = f.read()
        grid = [[e for e in line] for line in data.split('\n')]
        number = 0
        good_gear = False
        for l in range(len(grid)):
            for c in range(len(grid[l])):
                if grid[l][c].isdigit():
                    number = number * 10 + int(grid[l][c])
                    print(number)
                    c_bounds = slice(c-1 if c-1 >= 0 else 0, c+2 if c+1 < len(grid[l]) else c+1)
                    l_bounds = slice(l-1 if l-1 >= 0 else 0, l+2 if l+1 < len(grid) else l+1)
                    sub_list = [row[c_bounds] for row in grid[l_bounds]]
                    print(sub_list)
                    flat_list = [e for row in sub_list for e in row]
                    for sym in flat_list:
                        if sym != '.' and not sym.isdigit():
                            good_gear = True
                elif not grid[l][c].isdigit() and good_gear and number != 0:
                    sum_ += number
                    number = 0
                    good_gear = False
                else:
                    number = 0
                    good_gear = False
        print(sum_)


def main_2():
    sum_ = 0
    with open('gear.txt', 'r') as f:
        data = f.read()
        grid = [[e for e in line] for line in data.split('\n')]
        for l in range(len(grid)):
            for c in range(len(grid[l])):
                if grid[l][c] == '*':
                    c_bounds = slice(c - 1 if c - 1 >= 0 else 0, c + 2 if c + 1 < len(grid[l]) else c + 1)
                    l_bounds = slice(l - 1 if l - 1 >= 0 else 0, l + 2 if l + 1 < len(grid) else l + 1)
                    sub_list = [row[c_bounds] for row in grid[l_bounds]]
                    all_number_pos = []
                    for i, row in enumerate(sub_list):
                        for j, e in enumerate(row):
                            if e.isdigit():
                                if l == 0:
                                    l_di = i
                                else:
                                    l_di = l + i - 1
                                if c == 0 or c == len(grid[l]) - 1:
                                    c_di = j
                                else:
                                    c_di = c + j - 1
                                number_pos = [l_di, c_di]
                                while grid[number_pos[0]][number_pos[1]-1].isdigit():
                                    number_pos[1] -= 1
                                all_number_pos.append(number_pos)
                    unique_number_pos = [list(x) for x in set(tuple(x) for x in all_number_pos)]
                    if len(unique_number_pos) == 1:
                        continue
                    else:
                        ratio = 1
                        for pos in unique_number_pos:
                            number = 0
                            number = number * 10 + int(grid[pos[0]][pos[1]])
                            if pos[1] + 1 < len(grid[pos[0]]):
                                pos[1] += 1
                            while grid[pos[0]][pos[1]].isdigit():
                                number = number * 10 + int(grid[pos[0]][pos[1]])
                                if pos[1] + 1 < len(grid[pos[0]]):
                                    pos[1] += 1
                                else:
                                    break
                            print(number)
                            ratio *= number
                        sum_ += ratio
                        print(sum_)
        print(sum_)


if __name__ == '__main__':
    main_2()

