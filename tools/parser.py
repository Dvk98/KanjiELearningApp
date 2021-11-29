import json
import xmltodict

import gc
gc.collect()

kanji_reading = []
jlpt_list = []
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
jlpt_list.append([])
with open("JMdict_e.json", encoding="utf8") as f:
    data = json.load(f)
    for entry in data:
        try:
            type = entry["sense"][0]["pos"]
            meaning = entry["sense"][0]["gloss"]
            kanji = entry["k_ele"][0]["keb"]
            readings = []
            reading_list = entry["r_ele"]
            for reading in reading_list:
                readings.append(reading["reb"])
            kanji_reading.append([kanji, readings, 100, type, meaning])
        except:
            pass

with open("kanjidic2.json", encoding="utf8") as f:
    data = json.load(f)
    for entry in data:
        try:
            jlpt_list[entry["jlpt"]].append(entry["literal"])
        except:
            pass

N5 = []
n5 = False
N4 = []
n4 = False
N3 = []
n3 = False
N2 = []
n2 = False
N1 = []
n1 = False
with open("kanji.txt", encoding="utf8") as f:
    for i in f.readlines():
        i = i[:-1]
        if i == "N5":
            #print("LoL")
            n5 = True
        elif i == "N4":
            n5 = False
            n4 = True
        elif i == "N3":
            n4 = False
            n3 = True
        elif i == "N2":
            n3 = False
            n2 = True 
        elif i == "N1":
            n2 = False
            n1 = True
        else:
            if(n5):
                if(i != ""):
                    N5.append(i)
            elif(n4):
                if(i != ""):
                    N4.append(i)
            elif(n3):
                if(i != ""):
                    N3.append(i)
            elif(n2):
                if(i != ""):
                    N2.append(i)
            elif(n1):
                if(i != ""):
                    N1.append(i)

def Diff(li1, li2):
    return list(set(li1) - set(li2)) + list(set(li2) - set(li1))

N1 = jlpt_list[1]
N2 = Diff(jlpt_list[2], N3)

import csv
with open("Kanji_withJLPT.csv", "w", newline="", encoding="utf8") as csvfile:
    writer = csv.writer(csvfile, delimiter=",")
    writer.writerow(N5)
    writer.writerow(N4)
    writer.writerow(N3)
    writer.writerow(N2)
    writer.writerow(N1)

# vocab in form [kanji, reading, jlpt]
def getJLPT(N1, N2, N3, N4, N5, vocab):
    jlpt = 100
    word_list = vocab[0]
    for word in word_list:
        for kanji in word:
            #print(word)
            #print(kanji)
            if kanji in N1:
                return 1
            elif kanji in N2 and jlpt > 2:
                jlpt = 2
            elif kanji in N3 and jlpt > 3:
                jlpt = 3
            elif kanji in N4 and jlpt > 4:
                jlpt = 4
            elif kanji in N5 and jlpt > 5:
                jlpt = 5
    return jlpt

vocab_word_list = {"5": [], "4": [], "3": [], "2": [], "1": [], "0": []}
for vocab in kanji_reading:
    jlpt = getJLPT(N1, N2, N3, N4, N5, vocab)
    vocab[2] = jlpt

    if jlpt != 100:
        vocab_word_list[str(jlpt)].append(vocab)
    else:
        vocab_word_list["0"].append(vocab)

vocab_word_list_sorted = {"5": {}, "4": {}, "3": {}, "2": {}, "1": {}, "0": {}}
for jlpt in vocab_word_list:
    #print(jlpt)
    for word in vocab_word_list[jlpt]:
        if len(word[3]) > 1:
            wordtype = word[3][1]
        else:
            wordtype = word[3][0]
        print(f"{wordtype}: {'adj' in wordtype}")
        if "adj" in wordtype:
            wordtype = "adj"
        elif "v" in wordtype and "adv" not in wordtype:
            wordtype = "v"
        elif "n" in wordtype:
            wordtype = "n"
        wordtype = wordtype.replace("&", "")
        if wordtype not in vocab_word_list_sorted[jlpt]:
            vocab_word_list_sorted[jlpt][wordtype] = []
        vocab_word_list_sorted[jlpt][wordtype].append(word)


for jlpt in ["N5", "N4", "N3", "N2", "N1", "N0"]:
    for wordtype in vocab_word_list_sorted[jlpt[-1]]:
        with open(f"Wordlist_{jlpt}_{wordtype}.csv", "w", newline="", encoding="utf8") as csvfile:
            writer = csv.writer(csvfile, delimiter=",")
            writer.writerow(["Kanji", "Reading", "JLPT", "Type", "Meaning"])
            writer.writerows(vocab_word_list_sorted[jlpt[-1]][wordtype])
