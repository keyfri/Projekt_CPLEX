import random

m = 50;
p = 10;
n = 3;

max_cost = 10
max_puchasing_cost = 10
max_demands = 10
max_quantities = 20

file = 'data.dat'


def main():
    with open(file, 'w') as f:
        f.write("m = {};\n".format(m))
        f.write("p = {};\n".format(p))
        f.write("n = {};\n".format(n))
        f.write("\n")

        starts, ends = generate_S_and_D(m)
        s_set, d_set = generate_S_set_and_D_set(starts, ends)

        f.write("S_set = {};\n".format(s_set))
        f.write("S = {};\n\n".format(starts))

        f.write("D_set = {};\n".format(d_set))
        f.write("D = {};\n\n".format(ends))

        f.write("costs = {};\n\n".format(generate_numbers(m, m, max_cost)))
        f.write("cost_of_purchasing = {};\n\n".format(generate_numbers(m, n, max_puchasing_cost)))

        f.write("demands = {};\n\n".format(generate_numbers(n, p, max_demands)))

        f.write("q = {};\n\n".format(generate_numbers(m, n, max_quantities)))

        K = genrerate_K(p, n)
        f.write("K = {};\n\n".format(K))

        f.write("O = {};\n\n".format(generate_O(K, n)))
    print("DONE")

def generate_O(K, n):
    start_numbers = []
    for product in K:
        temp = []
        for order in range(1, len(product)+1):
            temp.append(order)
        for i in range(0, n - len(temp)):
            temp.append(0)
        random.shuffle(temp)
        start_numbers.append(temp)
    return [list(x) for x in zip(*start_numbers)]


def genrerate_K(p, n):
    temp = []
    for flow in range(0, p):
        temp2 = []
        for vsa in range(1, n+1):
            need_it_or_not = random.randint(1, 10)
            if need_it_or_not > 6:
                temp2.append(vsa)
        # wymus choc 1 liczbę w srodku
        if not temp2:
            temp2.append(1)
        temp.append(set(temp2))
    return temp


def generate_numbers(number_of_lists, list_size, max_value):
    costs = []
    for i in range(0, number_of_lists):
        costs.append([])
        for j in range(0, list_size):
            cost = random.randint(0, max_value)
            costs[i].append(cost)
    return costs


def generate_S_and_D(m):
    starts = []
    ends = []
    for start in range(0, p):
        start, end = generate_uniq_numbers(m)
        starts.append(start)
        ends.append(end)
    return starts, ends


def generate_S_set_and_D_set(starts, ends):
    s_set = []
    d_set = []
    for start in starts:
        s_set.append(set([start]))
    for end in ends:
        d_set.append(set([end]))
    return s_set, d_set


def generate_uniq_numbers(m):
    while True:
        start = random.randint(1, m)
        end = random.randint(1, m)
        if start != end:
            break
    return start, end


if __name__ == "__main__":
    main()
