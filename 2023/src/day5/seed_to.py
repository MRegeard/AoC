def main():
    with open("../../input/day5/seed_map.txt", "r") as f:
        seed_map = f.read()
#    with open("test_seed_to.txt", "r") as f:
#        seed_map = f.read()
    dict_map = {}
    seeds = []
    for i, entry in enumerate(seed_map.split('\n\n')):
        if i == 0:
            seeds = [int(e) for e in entry.split(':')[1].strip().split(' ')]
        else:
            dict_map[entry.split(':')[0].split(' ')[0]] = build_map_range(entry.split(':')[1])
    seeds_start = [s for s in seeds[::2]]
    seeds_range = [s for s in seeds[1::2]]
    loc = []
    for seed_start, seed_range in zip(seeds_start, seeds_range):
        print(f"doing seed: {seed_start} with range {seed_range}. {seed_start + seed_range} total to do!")
        for seed in range(seed_start, seed_start + seed_range):
            num = seed
            for k, val in dict_map.items():
                num = search_range(num, val)
            loc.append(num)
    print(loc)
    print(min(loc))


def search_range(num, dict_):
    value = num
    for dest, ran in zip(dict_["destination"], dict_["range"]):
        if dest <= num < dest + ran:
            return dict_["source"][dict_["destination"].index(dest)] + num - dest
    return value


def build_map_range(data):
    map_range = {"destination": [], "source": [], "range": []}
    for d in data.split('\n'):
        if d == '':
            continue
        d = d.split(' ')
        map_range["destination"].append(int(d[1]))
        map_range["source"].append(int(d[0]))
        map_range["range"].append(int(d[2]))
    return map_range



if __name__ == "__main__":
    main()