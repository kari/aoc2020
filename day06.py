with open('customs_answers.txt') as f:
    answers = list(map(lambda row: row.split("\n"), f.read().split("\n\n")))

print(sum(map(lambda answer: len(set().union(*answer))
, answers)))

print(sum(map(lambda answer: len(set(answer[0]).intersection(*answer)), answers)))
