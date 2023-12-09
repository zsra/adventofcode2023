def evaluate_hand(line, face):
    hand, bid = line.split()
    hand = hand.translate(str.maketrans('TJQKA', face))
    best = max(get_type(hand.replace('0', r)) for r in hand)
    return best, hand, int(bid)

def get_type(hand):
    return sorted(map(hand.count, hand), reverse=True)

def calculate_total_score(filename):
    for face in 'ABCDE', 'A0CDE':
        total_score = sum(rank * bid for rank, (*_, bid) in enumerate(sorted(map(lambda x: evaluate_hand(x, face), open(filename))), start=1))
        print(f"Score '{face}': {total_score}")

if __name__ == "__main__":
    calculate_total_score('day7.in')