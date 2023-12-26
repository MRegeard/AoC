def main():
    max_red = 12
    max_green = 13
    max_blue = 14
    game_sum = 0
    game_power = 0
    with open("game.txt", "r") as f:
        text = f.read()
        for line in text.split('\n'):
            draws = line.split(':')[1].split(';')
            possible = True
            minimum_cube = dict(red=0, green=0, blue=0)
            for draw in draws:
                cubes = draw.split(',')
                for cube in cubes:
                    c = cube.split(' ')[1:]
                    if c[1] == 'red':
                        minimum_cube['red'] = max(minimum_cube['red'], int(c[0]))
                        if int(c[0]) > max_red:
                            possible = False
                    elif c[1] == 'green':
                        minimum_cube['green'] = max(minimum_cube['green'], int(c[0]))
                        if int(c[0]) > max_green:
                            possible = False
                    elif c[1] == 'blue':
                        minimum_cube['blue'] = max(minimum_cube['blue'], int(c[0]))
                        if int(c[0]) > max_blue:
                            possible = False
            if possible:
                game_sum += int(line.split(':')[0].split(' ')[1])
            game_power += minimum_cube['red'] * minimum_cube['green'] * minimum_cube['blue']
    print(game_sum)
    print(game_power)


if __name__ == "__main__":
    main()