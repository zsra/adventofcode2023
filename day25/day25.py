import random

def read_input(filename):
    with open(filename, "r") as f:
        return [line.strip() for line in f]

def build_graph(input_arr):
    graph = {}
    for line in input_arr:
        a, links = line.split(": ")
        links = links.split(" ")
        for b in links:
            graph[a] = graph.get(a, []) + [b]
            graph[b] = graph.get(b, []) + [a]
    return graph

def get_comp_size(root, banned, graph):
    nodes = [root]
    seen = {root}
    while nodes:
        new_nodes = []
        for node in nodes:
            for neighbour in graph[node]:
                if neighbour in seen or (node, neighbour) in banned or (neighbour, node) in banned:
                    continue
                seen.add(neighbour)
                new_nodes.append(neighbour)
        nodes = new_nodes
    return len(seen)

def get_path(start, end, graph):
    prev = {start: start}
    nodes = [start]
    seen = {start}
    while nodes:
        new_nodes = []
        for node in nodes:
            for neighbour in graph[node]:
                if neighbour in seen:
                    continue
                seen.add(neighbour)
                prev[neighbour] = node
                new_nodes.append(neighbour)
        nodes = new_nodes

    if prev.get(end) is None:
        return None

    path = []
    node = end
    while node != start:
        path.append(node)
        node = prev[node]
    path.append(start)
    return path[::-1]

def main():
    filename = "day25.in"
    arr = read_input(filename)
    graph = build_graph(arr)

    uses = {}
    for _ in range(100):
        a, b = random.sample(list(graph.keys()), 2)
        path = get_path(a, b, graph)
        for i in range(len(path) - 1):
            edge = tuple(sorted([path[i], path[i + 1]]))
            uses[edge] = uses.get(edge, 0) + 1

    s_uses = sorted(uses.items(), key=lambda x: x[1], reverse=True)
    banned = [p[0] for p in s_uses[:3]]

    s1, s2 = get_comp_size(banned[0][0], banned, graph), get_comp_size(banned[0][1], banned, graph)
    print(s1 * s2)

if __name__ == "__main__":
    main()
